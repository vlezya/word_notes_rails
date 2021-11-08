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
  
  describe 'GET #index' do
    context 'with valid params' do
      before :all do
        Deck.destroy_all
        @deck = FactoryBot.create_list(:deck, 3)
      end
      
      before :each do
        get :index
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to have a proper amount of Decks' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('decks')).to eq(true)
        
        decks = json_response['decks']
        expect(decks.count).to eq(3)
      end
      
      it 'is expected to includes fields' do
        decks = JSON.parse(response.body)['decks']
        decks.each do |deck|
          expect(deck.key?('id')).to eq(true)
          expect(deck.key?('title')).to eq(true)
        end
      end
      
      it 'is expected to NOT include fields' do
        decks = JSON.parse(response.body)['decks']
        decks.each do |deck|
          expect(deck.key?('created_at')).to eq(false)
          expect(deck.key?('updated_at')).to eq(false)
        end
      end
    end
  end
      
  describe 'GET #show' do
    context 'with valid params' do
      before :all do
        Deck.destroy_all
        @deck = FactoryBot.create(:deck)
      end
      
      before :each do
        get :show, params: { id: @deck['id'] }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to return correct Deck' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('deck')).to eq(true)
        
        deck = json_response['deck']
        expect(deck).not_to eq(nil)
        
        deck_id = deck['id']
        expect(deck_id).to eq(@deck.id)
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
      before :each do
        @decks_before_request = Deck.count
        @deck_params = FactoryBot.attributes_for(:deck)
        post :create, params: { deck: @deck_params }
      end
      
      it 'is expected to have :created (201) HTTP response code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to created a new Deck' do
        expect(Deck.count).to eq(@decks_before_request + 1)
      end
      
      it 'is expected to set fields for Deck' do
        deck = Deck.order(id: :desc).first
        @deck_params.each do |key, value|
          expect(deck[key]).to eq(value)
        end
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
    let!(:deck){ FactoryBot.create(:deck) }
    
    context 'with valid params' do
      before :each do
        @decks_before_request = Deck.count
        @old_params = { title: 'My Deck'}
        @deck_params = FactoryBot.attributes_for(:deck)
        patch :update, params: { id: deck.id, deck: @deck_params }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to update fields for Deck' do
        deck.reload
        @deck_params.each do |key, value|
          expect(deck[key]).not_to eq(@old_params[key])
          expect(deck[key]).to eq(value)
        end
      end
      
      it 'is expected to NOT created a new deck' do
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
    
    context 'deck not found' do
      before :each do
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
    let!(:deck){ FactoryBot.create(:deck) }
    
    context 'with valid params' do
      before :each do
        @decks_before_request = Deck.count
        @old_params = { title: 'My Deck'}
        @deck_params = FactoryBot.attributes_for(:deck)
        patch :update, params: { id: deck.id, deck: @deck_params }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to update fields for Deck' do
        deck.reload
        @deck_params.each do |key, value|
          expect(deck[key]).not_to eq(@old_params[key])
          expect(deck[key]).to eq(value)
        end
      end
      
      it 'is expected to NOT created a new deck' do
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
    
    context 'deck not found' do
      before :each do
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
    let!(:deck){ FactoryBot.create(:deck) }
    
    context 'with valid params' do
      before :each do
        @deck_before_request = Deck.count
        delete :destroy, params: { id: deck.id }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content_type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to delete a deck' do
        expect(Deck.count).to eq(@deck_before_request - 1)
      end
      
      it 'is expected to delete the requested record' do
        expect { Deck.find(deck.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    context 'deck not found' do
      before :each do
        delete :destroy, params: { id: -1 }
      end
      
      it 'is expected to have :not_found (404) HTTP response code' do
        expect(response.status).to eq(404)
      end
      
      it 'should\'t change the size of the note relation' do
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
