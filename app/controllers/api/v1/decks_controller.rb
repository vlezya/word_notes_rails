class Api::V1::DecksController < ApplicationController
  
  # GET /api/v1/decks
  def index
    @decks = Deck.all
    decks_json = ActiveModel::Serializer::CollectionSerializer.new(@decks,
       each_serializer: DeckSerializer)
       
    render json: { decks: decks_json }, status: :ok
  end
  
  def show
    decks_json = DeckSerializer.new(@deck).as_json
    render json: { deck: decks_json }, status: :ok
  end
  
  # POST /api/v1/decks
  def create
    @deck = Deck.new(deck_params)
    
    if @deck.save
      decks_json = DeckSerializer.new(@deck).as_json
      render json: { deck: decks_json }, status: :created
    else
      render json: { errors: @deck.errors }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT  /api/v1/decks/:id
  def update
    if @deck.update(deck_params)
      decks_json = DeckSerializer.new(@deck).as_json
      render json: { deck: decks_json }, status: :ok
    else
      render json: { errors: @deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/decks/1
  def destroy
    @deck.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def deck_params
      params.require(:deck).permit(:title)
    end
end
