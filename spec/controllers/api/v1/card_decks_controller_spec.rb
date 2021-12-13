require 'rails_helper'

RSpec.describe Api::V1::CardDecksController, type: :controller do
  
  describe 'routing' do
    it 'routes GET /api/v1/card_decks to api/v1/card_decks#index' do
      expect(get: '/api/v1/card_decks').to route_to(
        controller: 'api/v1/card_decks',
        action: 'index',
        format: 'json'
      )
    end
    
    it 'routes POST /api/v1/decks/:deck_id/cards/:card_id/card_decks to api/v1/card_decks#create' do
      expect(post: '/api/v1/decks/10/cards/20/card_decks').to route_to(
        controller: 'api/v1/card_decks',
        action: 'create',
        deck_id: '10',
        card_id: '20',
        format: 'json'
      )
    end
    
    it 'routes DELETE api/v1/decks/:deck_id/cards/:card_id/card_decks/:id to api/v1/card_decks#destroy' do
      expect(delete: 'api/v1/decks/10/cards/20/card_decks/55').to route_to(
        controller: 'api/v1/card_decks',
        action: 'destroy',
        deck_id: '10',
        card_id: '20',
        id: '55',
        format: 'json'
      )
    end
  end
  
  before :all do
    @user = FactoryBot.create(:user)
    @session = FactoryBot.create(:session, user: @user)
  end
  
  describe 'GET #index' do
    context 'with valid params' do
      before :all do
        CardDeck.destroy_all
        card1 = FactoryBot.create(:card, user: @user)
        deck1 = FactoryBot.create(:deck, user: @user)
        card2 = FactoryBot.create(:card, user: @user)
        deck2 = FactoryBot.create(:deck, user: @user)
        card3 = FactoryBot.create(:card, user: @user)
        @card_deck = FactoryBot.create(:card_deck, card_id: card1.id, deck_id: deck1.id),
                     FactoryBot.create(:card_deck, card_id: card2.id, deck_id: deck2.id),
                     FactoryBot.create(:card_deck, card_id: card3.id, deck_id: deck2.id)
      end
      
      before :each do
        request.headers['X-Session-Token'] = @session.token
        get :index
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have proper amount of CardDecks' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('card_decks')).to eq(true)
        
        card_decks = json_response['card_decks']
        expect(card_decks.count).to eq(3)
      end
      
      it 'is expected to include fields' do
        card_decks = JSON.parse(response.body)['card_decks']
        card_decks.each do |card_deck|
          expect(card_deck.key?('id')).to eq(true)
          expect(card_deck.key?('card_id')).to eq(true)
          expect(card_deck.key?('deck_id')).to eq(true)
        end
      end
      
      it 'is expected to NOT include fields' do
        card_decks = JSON.parse(response.body)['card_decks']
        card_decks.each do |card_deck|
          expect(card_deck.key?('created_at')).to eq(false)
          expect(card_deck.key?('updated_at')).to eq(false)
        end
      end
    end
  end
end
