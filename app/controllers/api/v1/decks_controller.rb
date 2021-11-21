class Api::V1::DecksController < ApplicationController
  before_action :set_deck, only: [:show, :update, :destroy, :add_card, :remove_card]
  
  # GET /api/v1/decks
  def index
    decks = Deck.all
    decks_json = ActiveModel::Serializer::CollectionSerializer.new(decks, each_serializer: DeckSerializer)
    render json: { decks: decks_json}, status: :ok
  end
  
  # GET /api/v1/decks/:id
  def show
    deck_json = DeckSerializer.new(@deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  # POST /api/v1/decks
  def create
    deck = Deck.new(deck_params)
    deck.user = current_user
    
    if deck.save
      deck_json = DeckSerializer.new(deck).as_json
      render json: { deck: deck_json }, status: :created
    else
      render json: { errors: deck.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT  /api/v1/decks/:id
  def update
    if @deck.update(deck_params)
      deck_json = DeckSerializer.new(@deck).as_json
      render json: { deck: deck_json }, status: :ok
    else
      render json: { errors: deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/decks/1
  def destroy
    deck_json = DeckSerializer.new(@deck).as_json
    @deck.destroy
    render json: { deck: deck_json }, status: :ok
  end
  
  # POST /api/v1/decks/:id/add_card
  def add_card
    card = Card.find(params[:card_id])
    @deck.cards << card unless @deck.cards.include?(card)
    @deck.reload
    deck_json = DeckSerializer.new(@deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  def remove_card
    card = Card.find(params[:card_id])
    @deck.cards.delete(card)
    @deck.reload
    deck_json = DeckSerializer.new(@deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  # TODO: redo routes to match this
  # POST /api/v1/decks/:deck_id/cards/:id/add
  # DELETE /api/v1/decks/:deck_id/cards/:id/remove
  
  private
    def set_deck
      @deck = Deck.find(params[:id])
    end
    
    def deck_params
      params.require(:deck).permit(:title, card_ids: [])
    end
end
