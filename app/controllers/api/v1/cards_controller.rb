class Api::V1::CardsController < ApiController
  before_action :set_card, only: [:show, :update, :destroy, :decks]
  
  # GET /api/v1/cards
  def index
    authorize Card
    
    cards = current_user.cards.order(id: :desc)
    cards_json = ActiveModel::Serializer::CollectionSerializer.new(cards, each_serializer: CardSerializer)
    render json: { cards: cards_json }, status: :ok
  end
  
  # GET /api/v1/cards/:id
  def show
    authorize @card
    
    card_json = CardSerializer.new(@card).as_json
    render json: { card: card_json }, status: :ok
  end
  
  # POST /api/v1/cards
  def create
    card = Card.new(card_params)
    card.user = current_user
  
    authorize card
    
    if card.save
      card_json = CardSerializer.new(card).as_json
      render json: { card: card_json }, status: :created
    else
      render json: { errors: card.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT  /api/v1/cards/:id
  def update
    authorize @card
    
    if @card.update(card_params)
      card_json = CardSerializer.new(@card).as_json
      render json: { card: card_json }, status: :ok
    else
      render json: { errors: @card.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/cards/1
  def destroy
    authorize @card
    
    card_json = CardSerializer.new(@card).as_json
    if @card.destroy
      render json: { card: card_json }, status: :ok
    else
      render json: { errors: @card.errors }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/cards/:id/decks
  def decks
    authorize @card
    
    deck_ids = params[:deck_ids].map(&:to_i)
    created_card_deck_ids = []
    deck_ids.each do |deck_id|
      unless CardDeck.exists?(card: @card, deck_id: deck_id)
        created_card_deck_ids << CardDeck.create(card: @card, deck_id: deck_id).id
      end
    end
    
    existing_deck_ids = CardDeck.where(card: @card).pluck(:deck_id)
    deck_ids_to_delete = existing_deck_ids - deck_ids
    deleted_card_decks = CardDeck.where(card: @card, deck_id: deck_ids_to_delete).destroy_all
    created_card_decks = CardDeck.where(id: created_card_deck_ids)
    created_card_decks_json = ActiveModel::Serializer::CollectionSerializer.new(created_card_decks, each_serializer: CardDeckSerializer)
    deleted_card_decks_json = ActiveModel::Serializer::CollectionSerializer.new(deleted_card_decks, each_serializer: CardDeckSerializer)
    render json: { created_card_decks: created_card_decks_json, deleted_card_decks: deleted_card_decks_json }, status: :ok
  end
  
  private
    def set_card
      @card = Card.find(params[:id])
    end
    
    def card_params
      params.require(:card).permit(:word, :translation, :example)
    end
end
