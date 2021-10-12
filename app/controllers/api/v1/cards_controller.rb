class Api::V1::CardsController < ApplicationController
  before_action :set_card, only: [:show, :update, :destroy]

  # GET /api/v1/cards
  def index
    @cards = Card.all
    cards_json = ActiveModel::Serializer::CollectionSerializer.new(@cards, each_serializer: CardSerializer)
    render json: { cards: cards_json }
  end

  # GET /api/v1/cards/1
  def show
    card_json = CardSerializer.new(@card).as_json
    render json: { card: card_json }
  end

  # POST /api/v1/cards
  def create
    @card = Card.new(card_params)

    if @card.save
      card_json = CardSerializer.new(@card).as_json
      render json: { card: card_json }, status: :created
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT  /api/v1/cards/1
  def update
    if @card.update(card_params)
      card_json = CardSerializer.new(@card).as_json
      render json: { card: card_json }
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/cards/1
  def destroy
    @card.destroy
    card_json = CardSerializer.new(@card).as_json
    render json: { card: card_json }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = Card.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def card_params
    params.require(:card).permit(:word, :translation, :example)
  end
end
