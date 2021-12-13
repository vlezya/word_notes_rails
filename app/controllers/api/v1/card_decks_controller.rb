class Api::V1::CardDecksController < ApplicationController
  
  # GET /api/v1/card_decks
  def index
    card_decks = CardDeck.all
    card_decks_json = ActiveModel::Serializer::CollectionSerializer.new(card_decks, each_serializer: CardSerializer)
    render json: { card_decks: card_decks_json }, status: :ok
  end
  
  # POST /api/v1/decks/:deck_id/cards/:card_id/card_decks
  def create
    deck = Deck.find(params[:deck_id])
    deck.user = current_user
    card = Card.find(params[:card_id])
    card.user = current_user
    
    card_deck = CardDeck.new(card_deck_params)
    card_deck.card_id = card.id
    card_deck.deck_id = deck.id
    
    if card_deck.save
      card_deck_json = CardDeckSerializer.new(card_deck).as_json
      render json: { card_deck: card_deck_json }, status: :created
    else
      render json: { errors: card_deck.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/decks/:deck_id/cards/:card_id/card_decks/:id
  def destroy
    deck = Deck.find(params[:deck_id])
    card = Card.find(params[:card_id])
    card_deck = CardDeck.find(params[:id])
  
    card_deck_json = CardDeckSerializer.new(card_deck).as_json
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
