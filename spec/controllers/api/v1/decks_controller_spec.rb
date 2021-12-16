require 'rails_helper'

RSpec.describe Api::V1::DecksController, type: :controller do
  describe 'routing' do
    it 'routes GET /api/v1/decks to api/v1/decks#index' do
      expect(get: '/api/v1/decks').to route_to(
        controller: 'api/v1/decks',
        action: 'index',
        format: 'json'
      )
    end
    
    it 'routes GET /api/v1/decks/:id to api/v1/decks#show' do
      expect(get: 'api/v1/decks/1').to route_to(
        controller: 'api/v1/decks',
        action: 'show',
        id: '1',
        format: 'json'
      )
    end
    
    it 'routes POST /api/v1/decks to api/v1/decks#create' do
      expect(post: '/api/v1/decks').to route_to(
        controller: 'api/v1/decks',
        action: 'create',
        format: 'json'
      )
    end
    
    it 'routes PUT/PATCH api/v1/decks/:id to api/v1/decks#update' do
      expect(put: 'api/v1/decks/1').to route_to(
        controller: 'api/v1/decks',
        action: 'update',
        id: '1',
        format: 'json'
      )
      
      expect(patch: 'api/v1/decks/1').to route_to(
        controller: 'api/v1/decks',
        action: 'update',
        id: '1',
        format: 'json'
      )
    end
    
    it 'routes DELETE api/v1/decks/:id to api/v1/decks#destroy' do
      expect(delete: 'api/v1/decks/1').to route_to(
        controller: 'api/v1/decks',
        action: 'destroy',
        id: '1',
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
        Deck.destroy_all
        @card1 = FactoryBot.create(:card, user: @user)
        @card2 = FactoryBot.create(:card, user: @user)
        @deck1 = FactoryBot.create(:deck, user: @user)
        @deck2 = FactoryBot.create(:deck, user: @user)
        FactoryBot.create(:card_deck, card: @card1, deck: @deck1 )
        FactoryBot.create(:card_deck, card: @card2, deck: @deck1 )
        FactoryBot.create(:card_deck, card: @card2, deck: @deck2 )
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
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(Deck)
        call_index
      end
      
      it 'is expected to have a proper amount of Decks' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('decks')).to eq(true)
        
        deck = json_response['decks']
        expect(deck.count).to eq(2)
      end
      
      it 'is expected to includes fields Deck' do
        decks = JSON.parse(response.body)['decks']
        decks.each do |deck|
          expect(deck.key?('id')).to eq(true)
          expect(deck.key?('title')).to eq(true)
          expect(deck.key?('cards')).to eq(true)
          deck['cards'].each do |card|
            expect(card.key?('id')).to eq(true)
            expect(card.key?('word')).to eq(true)
            expect(card.key?('translation')).to eq(true)
            expect(card.key?('example')).to eq(true)
          end
        end
      end
      
      it 'is expected to NOT include fields' do
        decks = JSON.parse(response.body)['decks']
        decks.each do |deck|
          expect(deck.key?('created_at')).to eq(false)
          expect(deck.key?('updated_at')).to eq(false)
          deck['cards'].each do |card|
            expect(deck.key?('created_at')).to eq(false)
            expect(deck.key?('updated_at')).to eq(false)
          end
        end
      end
      
      it 'is expected to return a correct Deck with Cards' do
        decks = JSON.parse(response.body)['decks']
        
        json_deck1 = decks.find { |deck| deck['id'] == @deck1.id }
        expect(json_deck1).not_to eq(nil)
        expect(json_deck1['cards'].count).to eq(2)
        
        json_deck2 = decks.find { |deck| deck['id'] == @deck2.id }
        expect(json_deck2).not_to eq(nil)
        expect(json_deck2['cards'].count).to eq(1)
      end
    end
  end
      
  describe 'GET #show' do
    context 'with valid params' do
      before :all do
        Deck.destroy_all
        @card1 = FactoryBot.create(:card, user: @user)
        @card2 = FactoryBot.create(:card, user: @user)
        @deck = FactoryBot.create(:deck, user: @user)
        @card_deck1 = FactoryBot.create(:card_deck, card: @card1, deck: @deck)
        @card_deck2 = FactoryBot.create(:card_deck, card: @card2, deck: @deck)
      end
      
      def call_show
        request.headers['X-Session-Token'] = @session.token
        get :show, params: { id: @deck.id }
      end
      
      before :each do
        call_show
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(@deck)
        call_show
      end
      
      it 'is expected to return correct Deck' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('deck')).to eq(true)
        
        deck = json_response['deck']
        deck_id = deck['id']
        expect(deck_id).to eq(@deck.id)
        expect(deck).not_to eq(nil)
        expect(deck['cards'].count).to eq(2)
      end
      
      it 'is expected to include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('id')).to eq(true)
        expect(deck.key?('title')).to eq(true)
        expect(deck.key?('cards')).to eq(true)
        deck['cards'].each do |card|
          expect(card.key?('id')).to eq(true)
          expect(card.key?('word')).to eq(true)
          expect(card.key?('translation')).to eq(true)
          expect(card.key?('example')).to eq(true)
        end
      end
      
      it 'is expected to NOT include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('created_at')).to eq(false)
        expect(deck.key?('updated_at')).to eq(false)
        deck['cards'].each do |card|
          expect(deck.key?('created_at')).to eq(false)
          expect(deck.key?('updated_at')).to eq(false)
        end
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
      
      it 'is expected to return application/json content_type' do
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
        @decks_before_request = Deck.count
        @deck_params = FactoryBot.attributes_for(:deck)
        
        request.headers['X-Session-Token'] = @session.token
        post :create, params: { deck: @deck_params }
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
      
      it 'is expected to created a new Deck' do
        expect(Deck.count).to eq(@decks_before_request + 1)
      end
      
      it 'is expected to set fields for Deck' do
        deck = Deck.order(id: :desc).first
        expect(@deck_params[:title]).to eq(deck[:title])
      end
      
      it 'is expected to include fields' do
        json_response = JSON.parse(response.body)['deck']
        expect(json_response.key?('id')).to eq(true)
        expect(json_response.key?('title')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        json_response = JSON.parse(response.body)['deck']
        expect(json_response.key?('created_at')).to eq(false)
        expect(json_response.key?('updated_at')).to eq(false)
      end
    end
  end
  
  describe 'PATCH #update' do
    context 'with valid params' do
      let!(:deck) { FactoryBot.create(:deck, user: @user) }
      
      def call_update
        @decks_before_request = Deck.count
        @old_title = deck.reload.title
        @deck_params = FactoryBot.attributes_for(:deck)
        
        request.headers['X-Session-Token'] = @session.token
        patch :update, params: { id: deck.id, deck: @deck_params }
      end

      before :each do
        call_update
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(deck)
        call_update
      end
      
      it 'is expected to update fields for Deck' do
        deck.reload
        expect(@deck_params[:title]).not_to eq(@old_title)
        expect(@deck_params[:title]).to eq(deck[:title])
      end
      
      it 'is expected to NOT create a new Deck' do
        expect(Deck.count).to eq(@decks_before_request)
      end
      
      it 'is expected to include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('id')).to eq(true)
        expect(deck.key?('title')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('created_at')).to eq(false)
        expect(deck.key?('updated_at')).to eq(false)
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
      let!(:deck) { FactoryBot.create(:deck, user: @user) }
      
      def call_update
        @decks_before_request = Deck.count
        @old_title = deck.reload.title
        @deck_params = FactoryBot.attributes_for(:deck)
        
        request.headers['X-Session-Token'] = @session.token
        put :update, params: { id: deck.id, deck: @deck_params }
      end
      
      before :each do
        call_update
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to call authorize (Pundit)' do
        expect(controller).to receive(:authorize).with(deck)
        call_update
      end
      
      it 'is expected to update fields for Deck' do
        deck.reload
        expect(@deck_params[:title]).not_to eq(@old_title)
        expect(@deck_params[:title]).to eq(deck[:title])
      end
      
      it 'is expected to NOT created a new Deck' do
        expect(Deck.count).to eq(@decks_before_request)
      end
      
      it 'is expected to include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('id')).to eq(true)
        expect(deck.key?('title')).to eq(true)
      end
      
      it 'is expected to NOT include fields' do
        deck = JSON.parse(response.body)['deck']
        expect(deck.key?('created_at')).to eq(false)
        expect(deck.key?('updated_at')).to eq(false)
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
        @deck = FactoryBot.create(:deck, user: @user) unless @deck&.persisted?
        @decks_before_request = Deck.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: @deck.id }
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
        @deck = FactoryBot.create(:deck, user: @user)
        expect(controller).to receive(:authorize).with(@deck)
        call_destroy
      end
      
      it 'is expected to delete a Deck' do
        expect(Deck.count).to eq(@decks_before_request - 1)
      end
    end
    
    context 'NOT found' do
      before :each do
        @decks_before_request = Deck.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { id: - 1  }
      end
      
      it 'is expected to have :not_found (404) HTTP response code' do
        expect(response.status).to eq(404)
      end
      
      it 'should NOT change the size of the note relation' do
          expect{ Deck.count }.to_not change{ @decks_before_request }
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
