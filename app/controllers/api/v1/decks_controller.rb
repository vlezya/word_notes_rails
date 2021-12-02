class Api::V1::DecksController < ApplicationController
  before_action :set_deck, only: [:show, :update, :destroy]
  
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
  
  # DELETE /api/v1/decks/1
  def destroy
    authorize @deck
    
    deck_json = DeckSerializer.new(@deck).as_json
    @deck.destroy
    render json: { deck: deck_json }, status: :ok
  end
  
  # POST /api/v1/decks/:deck_id/cards/:id/add
  def add
    deck = Deck.find(params[:deck_id])
    deck.user = current_user
    card = Card.find(params[:id])
    
    authorize deck
    
    deck.cards << card unless deck.cards.include?(card)
    deck.reload
    deck_json = DeckSerializer.new(deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  # DELETE /api/v1/decks/:deck_id/cards/:id/remove
  def remove
    deck = Deck.find(params[:deck_id])
    card = Card.find(params[:id])
    
    authorize deck
    
    deck.cards.delete(card)
    deck.reload
    deck_json = DeckSerializer.new(deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  private
    def set_deck
      @deck = Deck.find(params[:id])
    end
    
    def deck_params
      params.require(:deck).permit(:title)
    end
end
