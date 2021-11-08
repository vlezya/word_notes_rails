class Api::V1::DecksController < ApplicationController
  before_action :set_deck, only: [:show, :update, :destroy]
  # GET /api/v1/deck
  def index
    @decks = Deck.all
    decks_json = ActiveModel::Serializer::CollectionSerializer.new(@decks, each_serializer: DeckSerializer)
       
    render json: { decks: decks_json }, status: :ok
  end
  
  # GET /api/v1/decks/:id
  def show
    deck_json = DeckSerializer.new(@deck).as_json
    render json: { deck: deck_json }, status: :ok
  end
  
  # POST /api/v1/decks
  def create
    @deck = Deck.new(deck_params)
    
    if @deck.save
      deck_json = DeckSerializer.new(@deck).as_json
      render json: { deck: deck_json }, status: :created
    else
      render json: { errors: @deck.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT  /api/v1/decks/:id
  def update
    if @deck.update(deck_params)
      deck_json = DeckSerializer.new(@deck).as_json
      render json: { deck: deck_json }, status: :ok
    else
      render json: { errors: @deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/deck/1
  def destroy
    @deck.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def set_deck
      @deck = Deck.find(params[:id])
    end
    
    def deck_params
      params.require(:deck).permit(:title)
    end
end
