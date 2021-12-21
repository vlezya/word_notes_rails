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
    
    it 'routes POST /api/v1/card_decks to api/v1/card_decks#create' do
      expect(post: '/api/v1/card_decks').to route_to(
        controller: 'api/v1/card_decks',
        action: 'create',
        format: 'json'
      )
    end
    
    it 'routes DELETE api/v1/card_decks/:id to api/v1/card_decks#destroy' do
      expect(delete: 'api/v1/card_decks/CARD_DECK_ID').to route_to(
        controller: 'api/v1/card_decks',
        action: 'destroy',
        id: 'CARD_DECK_ID',
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
        card2 = FactoryBot.create(:card, user: @user)
        card3 = FactoryBot.create(:card, user: @user)
        
        deck1 = FactoryBot.create(:deck, user: @user)
        deck2 = FactoryBot.create(:deck, user: @user)
        
        FactoryBot.create(:card_deck, card_id: card1.id, deck_id: deck1.id)
        FactoryBot.create(:card_deck, card_id: card2.id, deck_id: deck2.id)
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
  
  describe 'POST #create' do
    context 'with valid params' do
      def call_create
        card = FactoryBot.create(:card, user: @user)
        deck = FactoryBot.create(:deck, user: @user)
        @card_decks_before_request = CardDeck.count
        @card_deck_params = FactoryBot.attributes_for(:card_deck, card_id: card.id, deck_id: deck.id)
        
        request.headers['X-Session-Token'] = @session.token
        post :create, params: { card_deck: @card_deck_params }
      end
      
      before :each do
        call_create
      end
      
      it 'is expected to have :created (201) HTTP response code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize)
        call_create
      end
      
      it 'is expected to created a new CardDeck' do
        expect(CardDeck.count).to eq(@card_decks_before_request + 1)
      end
      
      it 'is expected to set fields for CardDeck' do
        card_deck = CardDeck.order(id: :desc).first
        expect(@card_deck_params[:card_id]).to eq(card_deck[:card_id])
        expect(@card_deck_params[:deck_id]).to eq(card_deck[:deck_id])
      end
      
      it 'is expected to include fields' do
        json_response = JSON.parse(response.body)['card_deck']
        expect(json_response.key?('id')).to eq(true)
        expect(json_response.key?('card_id')).to eq(true)
        expect(json_response.key?('deck_id')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        json_response = JSON.parse(response.body)['card_deck']
        expect(json_response.key?('created_at')).to eq(false)
        expect(json_response.key?('updated_at')).to eq(false)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'with valid params' do
      def call_destroy
        @card = FactoryBot.create(:card, user: @user)
        @deck = FactoryBot.create(:deck, user: @user)
        @card_deck = FactoryBot.create(:card_deck, card: @card, deck: @deck) unless @card_deck&.persisted?
        @card_deck_count_before_request = CardDeck.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: @card_deck.id }
      end
      
      before :each do
        call_destroy
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(@card_deck)
        call_destroy
      end
      
      it 'is expected to remove a CardDeck' do
        expect(CardDeck.count).to eq(@card_deck_count_before_request - 1)
      end
      
      it 'is expected to include fields' do
        card_deck = JSON.parse(response.body)['card_deck']
        expect(card_deck.key?('id')).to eq(true)
        expect(card_deck.key?('card_id')).to eq(true)
        expect(card_deck.key?('deck_id')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        card_deck = JSON.parse(response.body)['card_deck']
        expect(card_deck.key?('created_at')).to eq(false)
        expect(card_deck.key?('updated_at')).to eq(false)
      end
    end
    
    context 'NOT found' do
      before :each do
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: -1 }
      end
      
      it 'is expected to have :not_found (404) HTTP response code' do
        expect(response.status).to eq(404)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to return errors' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('errors')).to eq(true)
      end
    end
  end
end
