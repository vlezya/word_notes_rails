require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :controller do
  
  describe 'routing' do
    it 'routes GET /api/v1/cards to api/v1/cards#index' do
      expect(get: '/api/v1/cards').to route_to(
        controller: 'api/v1/cards',
        action: 'index',
        format: 'json'
      )
    end
    
    it 'routes GET /api/v1/cards/:id to api/v1/cards#show' do
      expect(get: '/api/v1/cards/55').to route_to(
        controller: 'api/v1/cards',
        action: 'show',
        id: '55',
        format: 'json'
      )
    end
    
    it 'routes POST /api/v1/cards/ to api/v1/cards#create' do
      expect(post: '/api/v1/cards').to route_to(
        controller: 'api/v1/cards',
        action: 'create',
        format: 'json'
      )
    end
    
    it 'routes PUT/PATCH api/v1/cards/:id to api/v1/cards#update' do
      expect(patch: 'api/v1/cards/55').to route_to(
        controller: 'api/v1/cards',
        action: 'update',
        id: '55',
        format: 'json'
      )
      
      expect(put: 'api/v1/cards/55').to route_to(
        controller: 'api/v1/cards',
        action: 'update',
        id: '55',
        format: 'json'
      )
    end
    
    it 'routes DELETE api/v1/cards/:id to api/v1/cards#destroy' do
      expect(delete: 'api/v1/cards/55').to route_to(
        controller: 'api/v1/cards',
        action: 'destroy',
        id: '55',
        format: 'json'
      )
    end
    
    it 'routes PUT api/v1/cards/:id/decks to api/v1/cards#decks' do
      expect(put: 'api/v1/cards/CARD_ID/decks').to route_to(
        controller: 'api/v1/cards',
        action: 'decks',
        id: 'CARD_ID',
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
        Card.destroy_all
        @card = FactoryBot.create_list(:card, 5, user: @user)
      end
      
      def call_index
        request.headers['X-Session-Token'] = @session.token
        get :index
      end
      
      before :each do
        call_index
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(Card)
        call_index
      end
      
      it 'is expected to have proper amount of Cards' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('cards')).to eq(true)
        
        cards = json_response['cards']
        expect(cards.count).to eq(5)
      end
      
      it 'is expected to include fields' do
        cards = JSON.parse(response.body)['cards']
        cards.each do |card|
          expect(card.key?('id')).to eq(true)
          expect(card.key?('word')).to eq(true)
          expect(card.key?('translation')).to eq(true)
          expect(card.key?('example')).to eq(true)
        end
      end
      
      it 'is expected to NOT include fields' do
        cards = JSON.parse(response.body)['cards']
        cards.each do |card|
          expect(card.key?('created_at')).to eq(false)
          expect(card.key?('updated_at')).to eq(false)
        end
      end
    end
  end
  
  describe 'GET #show' do
    context 'with valid params' do
      before :all do
        Card.destroy_all
        @card = FactoryBot.create(:card, user: @user)
      end
      
      def call_show
        request.headers['X-Session-Token'] = @session.token
        get :show, params: { id: @card.id }
      end
      
      before :each do
        call_show
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(@card)
        call_show
      end
      
      it 'is expected to return correct Card' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('card')).to eq(true)
        
        card = json_response['card']
        expect(card).not_to eq(nil)
        
        card_id = card['id']
        expect(card_id).to eq(@card.id)
      end
      
      it 'is expected to include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('id')).to eq(true)
        expect(card.key?('word')).to eq(true)
        expect(card.key?('translation')).to eq(true)
        expect(card.key?('example')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('created_at')).to eq(false)
        expect(card.key?('updated_at')).to eq(false)
      end
    end
    
    context 'NOT found' do
      before :each do
        request.headers['X-Session-Token'] = @session.token
        get :show, params: { id: -1 }
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
  
  describe 'POST #create' do
    context 'with valid params' do
      def call_create
        @cards_before_request = Card.count
        @card_params = FactoryBot.attributes_for(:card)
        
        request.headers['X-Session-Token'] = @session.token
        post :create, params: { card: @card_params }
      end
      
      before :each do
        call_create
      end
      
      it 'is expected to have :created (201) HTTP response code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize)
        call_create
      end
      
      it 'is expected to crete a new Card' do
        expect(Card.count).to eq(@cards_before_request + 1)
      end
      
      it 'is expected to set fields for Card' do
        card = Card.order(id: :desc).first
        @card_params.each do |key, value|
          expect(card[key]).to eq(value)
        end
      end
      
      it 'is expected to include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('id')).to eq(true)
        expect(card.key?('word')).to eq(true)
        expect(card.key?('translation')).to eq(true)
        expect(card.key?('example')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('created_at')).to eq(false)
        expect(card.key?('updated_at')).to eq(false)
      end
    end
  end
  
  describe 'PATCH #update' do
    context 'with valid params' do
      let!(:card) { FactoryBot.create(:card, user: @user) }
      
      def call_update
        @cards_before_request = Card.count
        @old_params = { word: card.word, translation: card.translation, example: card.example }
        @new_params = FactoryBot.attributes_for(:card)
        
        request.headers['X-Session-Token'] = @session.token
        patch :update, params: { id: card.id, card: @new_params }
      end
      
      before :each do
        call_update
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(card)
        call_update
      end
      
      it 'is expected to update fields for Card' do
        card.reload
        @new_params.each do |key, value|
          expect(card[key]).not_to eq(@old_params[key])
          expect(card[key]).to eq(value)
        end
      end
      
      it 'is expected to NOT create a new card' do
        expect(Card.count).to eq(@cards_before_request)
      end
      
      it 'is expected to include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('id')).to eq(true)
        expect(card.key?('word')).to eq(true)
        expect(card.key?('translation')).to eq(true)
        expect(card.key?('example')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('created_at')).to eq(false)
        expect(card.key?('updated_at')).to eq(false)
      end
    end
    
    context 'NOT found' do
      before :each do
        request.headers['X-Session-Token'] = @session.token
        patch :update, params: { id: -1 }
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
  
  describe 'PUT #update' do
    context 'with valid params' do
      let!(:card) { FactoryBot.create(:card, user: @user) }
      
      def call_update
        @cards_before_request = Card.count
        @old_params = { word: card.word, translation: card.translation, example: card.example }
        @new_params = FactoryBot.attributes_for(:card)
        
        request.headers['X-Session-Token'] = @session.token
        put :update, params: { id: card.id, card: @new_params }
      end
      
      before :each do
        call_update
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(card)
        call_update
      end
      
      it 'is expected to update fields for Card' do
        card.reload
        @new_params.each do |key, value|
          expect(card[key]).not_to eq(@old_params[key])
          expect(card[key]).to eq(value)
        end
      end
      
      it 'is expected to NOT create a new card' do
        expect(Card.count).to eq(@cards_before_request)
      end
      
      it 'is expected to include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('id')).to eq(true)
        expect(card.key?('word')).to eq(true)
        expect(card.key?('translation')).to eq(true)
        expect(card.key?('example')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        card = JSON.parse(response.body)['card']
        expect(card.key?('created_at')).to eq(false)
        expect(card.key?('updated_at')).to eq(false)
      end
    end
    
    context 'NOT found' do
      before :each do
        request.headers['X-Session-Token'] = @session.token
        patch :update, params: { id: -1 }
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
  
  describe 'DELETE #destroy' do
    context 'with valid params' do
      def call_destroy
        @card = FactoryBot.create(:card, user: @user) unless @card&.persisted?
        @cards_before_request = Card.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: @card.id }
      end
      
      before :each do
        call_destroy
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        @card = FactoryBot.create(:card, user: @user)
        expect(controller).to receive(:authorize).with(@card)
        call_destroy
      end
      
      it 'is expected to delete a Card' do
        expect(Card.count).to eq(@cards_before_request - 1)
      end
      
      it 'is expected to delete the requested record' do
        expect { Card.find(@card.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    context 'NOT found' do
      before :each do
        @cards_before_request = Card.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: -1 }
      end
      
      it 'is expected to have :not_found (404) HTTP response code' do
        expect(response.status).to eq(404)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'should NOT change the size of the note relation' do
        expect{ Card.count }.to_not change{ @cards_before_request }
      end
      
      it 'is expected to return errors' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('errors')).to eq(true)
      end
    end
  end
  
  describe 'PUT #decks' do
    context 'with valid params' do
      def call_decks
        @card = FactoryBot.create(:card, user: @user)
        @deck1 = FactoryBot.create(:deck, user: @user)
        @deck2 = FactoryBot.create(:deck, user: @user)
        @deck3 = FactoryBot.create(:deck, user: @user)
        @card_deck1 = FactoryBot.create(:card_deck, card: @card, deck: @deck1)
        @card_deck2 = FactoryBot.create(:card_deck, card: @card, deck: @deck2)
        
        request.headers['X-Session-Token'] = @session.token
        put :decks, params: { id: @card.id, deck_ids: [@deck1.id, @deck3.id] }
      end
      
      before :each do
        call_decks
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize)
        call_decks
      end
      
      it 'is expected to retain existing CardDeck for Deck in :deck_ids' do
        expect(CardDeck.exists?(card: @card, deck: @deck1)).to eq(true)
      end
      
      it 'is expected to destroy CardDeck for Deck NOT in :deck_ids' do
        expect(CardDeck.exists?(card: @card, deck: @deck2)).to eq(false)
      end
      
      it 'is expected to create new CardDeck for Deck in :deck_ids' do
        expect(CardDeck.exists?(card: @card, deck: @deck3)).to eq(true)
      end
      
      it 'is expected to include fields to created CardDeck and deleted CardDeck' do
        create_card_decks = JSON.parse(response.body)['created_card_decks']
        create_card_decks.each do |create_card_deck|
          expect(create_card_deck.key?('id')).to eq(true)
          expect(create_card_deck.key?('card_id')).to eq(true)
          expect(create_card_deck.key?('deck_id')).to eq(true)
        end
        
        delete_card_decks = JSON.parse(response.body)['deleted_card_decks']
        delete_card_decks.each do |delete_card_deck|
          expect(delete_card_deck.key?('id')).to eq(true)
          expect(delete_card_deck.key?('card_id')).to eq(true)
          expect(delete_card_deck.key?('deck_id')).to eq(true)
        end
      end
      
      it 'is expected to NOT include fields to created CardDeck and deleted CardDeck' do
        create_card_decks = JSON.parse(response.body)['created_card_decks']
        create_card_decks.each do |create_card_deck|
          expect(create_card_deck.key?('created_at')).to eq(false)
          expect(create_card_deck.key?('updated_at')).to eq(false)
        end
        
        delete_card_decks = JSON.parse(response.body)['deleted_card_decks']
        delete_card_decks.each do |delete_card_deck|
          expect(delete_card_deck.key?('created_at')).to eq(false)
          expect(delete_card_deck.key?('updated_at')).to eq(false)
        end
      end
    end
  end
end
