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
        @card1 = FactoryBot.create(:card)
        @card2 = FactoryBot.create(:card)
        @card3 = FactoryBot.create(:card)
        @deck1 = FactoryBot.create(:deck)
        @deck2 = FactoryBot.create(:deck, cards: [@card1, @card2])
        @deck3 = FactoryBot.create(:deck, cards: [@card3])
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
        
        deck = json_response['decks']
        expect(deck.count).to eq(3)
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
      
      it "is expected to return a correct Deck with Cards" do
        decks = JSON.parse(response.body)['decks']
        
        json_deck1 = decks.find { |deck| deck['id'] == @deck1.id }
        expect(json_deck1).not_to eq(nil)
        expect(json_deck1['cards'].count).to eq(0)
        
        json_deck2 = decks.find { |deck| deck['id'] == @deck2.id }
        expect(json_deck2).not_to eq(nil)
        expect(json_deck2['cards'].count).to eq(2)
        
        json_deck3 = decks.find { |deck| deck['id'] == @deck3.id }
        expect(json_deck3).not_to eq(nil)
        expect(json_deck3['cards'].count).to eq(1)
      end
    end
  end
      
  describe 'GET #show' do
    context 'with valid params' do
      before :all do
        Deck.destroy_all
        @cards = FactoryBot.create_list(:card, 3)
        @deck = FactoryBot.create(:deck, cards: @cards)
      end
      
      before :each do
        get :show, params: { id: @deck.id }
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
        deck_id = deck['id']
        expect(deck_id).to eq(@deck.id)
        expect(deck).not_to eq(nil)
        expect(deck['cards'].count).to eq(3)
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
    let!(:deck) { FactoryBot.create(:deck) }
    
    context 'with valid params' do
      before :each do
        @decks_before_request = Deck.count
        @old_title = deck.reload.title
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
          expect(deck[key]).not_to eq(@old_title)
          expect(deck[key]).to eq(value)
        end
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
    
    context 'Deck NOT found' do
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
    let!(:deck) { FactoryBot.create(:deck) }
    
    context 'with valid params' do
      before :each do
        @decks_before_request = Deck.count
        @old_title = deck.reload.title
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
          expect(deck[key]).not_to eq(@old_title)
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
