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
    
    it ' routes DELETE api/v1/cards/:id to api/v1/cards#destroy' do
      expect(delete: 'api/v1/cards/55').to route_to(
        controller: 'api/v1/cards',
        action: 'destroy',
        id: '55',
        format: 'json'
      )
    end
  end
  
  describe 'GET #index' do
    context 'with valid params' do
      before :all do
        Card.destroy_all
        @card = FactoryBot.create_list(:card, 5)
      end
      
      before :each do
        get :index
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
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
        @card = FactoryBot.create(:card)
      end
      
      before :each do
        get :show, params: { id: @card['id'] }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
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
    
    context 'not found' do
      before :each do
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
      before :each do
        @cards_before_request = Card.count
        @card_params = FactoryBot.attributes_for(:card)
        post :create, params: { card: @card_params }
      end
      
      it 'is expected to have :created (201) HTTP response code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
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
    let!(:card) { FactoryBot.create(:card) }
    
    context 'with valid params' do
      before :each do
        @cards_before_request = Card.count
        @old_params = { word: card.word, translation: card.translation, example: card.example }
        @new_params = FactoryBot.attributes_for(:card)
        patch :update, params: { id: card.id, card: @new_params }
      end
  
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to update fields for Card' do
        card.reload
        @new_params.each do |key, value|
          expect(card[key]).not_to eq(@old_params[key])
          expect(card[key]).to eq(value)
        end
      end
      
      it "is expected to NOT create a new card" do
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
    
    context 'card not found' do
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
    let!(:card) { FactoryBot.create(:card) }
    
    context 'with valid params' do
      before :each do
        @cards_before_request = Card.count
        @old_params = { word: card.word, translation: card.translation, example: card.example }
        @new_params = FactoryBot.attributes_for(:card)
        patch :update, params: { id: card.id, card: @new_params }
      end
  
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to update fields for Card' do
        card.reload
        @new_params.each do |key, value|
          expect(card[key]).not_to eq(@old_params[key])
          expect(card[key]).to eq(value)
        end
      end
      
      it "is expected to NOT create a new card" do
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
    
    context 'card not found' do
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
    let!(:card) { FactoryBot.create(:card) }
    
    context 'with valid params' do
      before :each do
        @cards_before_request = Card.count
        delete :destroy, params: { id: card.id }
      end
      
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to delete a Card' do
        expect(Card.count).to eq(@cards_before_request - 1)
      end
      
      it 'is expected to delete the requested record' do
        expect { Card.find(card.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    context 'card not found' do
      before :each do
        delete :destroy, params: { id: -1 }
      end
      
      it 'is expected to have :not_found (404) HTTP response code' do
        expect(response.status).to eq(404)
      end
      
      it 'should\'t change the size of the note relation' do
          expect{ Card.count }.to_not change{ @cards_before_request }
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
