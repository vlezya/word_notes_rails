class Api::V1::CardDecksController < ApplicationController
  
  # GET /api/v1/card_decks
  def index
    authorize CardDeck
    
    card_decks = CardDeck.joins(:card, :deck).where(cards: { user_id: current_user.id }).where(decks: { user_id: current_user.id }).order(id: :desc)
    card_decks_json = ActiveModel::Serializer::CollectionSerializer.new(card_decks, each_serializer: CardDeckSerializer)
    render json: { card_decks: card_decks_json }, status: :ok
  end
  
  # POST /api/v1/card_decks
  def create
    card_deck = CardDeck.find_or_create_by(card_deck_params)
    
    authorize card_deck
    
    if card_deck
      card_deck_json = CardDeckSerializer.new(card_deck).as_json
      render json: { card_deck: card_deck_json }, status: :created
    else
      render json: { errors: card_deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/card_decks/:id
  def destroy
    card_deck = CardDeck.find(params[:id])
    card_deck_json = CardDeckSerializer.new(card_deck).as_json
    
    authorize card_deck
    
    if card_deck.destroy
      render json: { card_deck: card_deck_json }, status: :ok
    else
      render json: { errors: card_deck.errors }, status: :unprocessable_entity
    end
  end
  
  private
    def card_deck_params
      params.require(:card_deck).permit(:card_id, :deck_id)
    end
end
