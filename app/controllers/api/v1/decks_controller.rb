class Api::V1::DecksController < ApiController
  before_action :set_deck, only: [:show, :update, :destroy, :cards]
  
  # GET /api/v1/decks
  def index
    authorize Deck
    
    decks = current_user.decks.order(id: :desc)
    decks_json = ActiveModel::Serializer::CollectionSerializer.new(decks, each_serializer: DeckSerializer)
    render json: { decks: decks_json }, status: :ok
  end
  
  # GET /api/v1/decks/:id
  def show
    authorize @deck
    
    deck_json = DeckSerializer.new(@deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  # POST /api/v1/decks
  def create
    deck = Deck.new(deck_params)
    deck.user = current_user
    
    authorize deck
    
    if deck.save
      deck_json = DeckSerializer.new(deck).as_json
      render json: { deck: deck_json }, status: :created
    else
      render json: { errors: deck.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT  /api/v1/decks/:id
  def update
    authorize @deck
    
    if @deck.update(deck_params)
      deck_json = DeckSerializer.new(@deck).as_json
      render json: { deck: deck_json }, status: :ok
    else
      render json: { errors: deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/decks/:id
  def destroy
    authorize @deck
    
    deck_json = DeckSerializer.new(@deck).as_json
    @deck.destroy
    render json: { deck: deck_json }, status: :ok
  end
  
  # DELETE /api/v1/decks/:id/remove_cards
  def cards
    authorize @deck
    
    existing_card_ids = CardDeck.where(deck: @deck).pluck(:card_id)
    deleted_cards = Card.where(id: existing_card_ids).destroy_all
    deleted_cards_json = ActiveModel::Serializer::CollectionSerializer.new(deleted_cards, each_serializer: CardDeckSerializer)
    @deck.destroy
    render json: { deleted_cards: deleted_cards_json }, status: :ok
  end
  
  private
    def set_deck
      @deck = Deck.find(params[:id])
    end
    
    def deck_params
      params.require(:deck).permit(:title)
    end
end
