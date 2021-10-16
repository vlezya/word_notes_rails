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
  end
  
  describe 'GET #index' do
    before :all do
      Card.destroy_all
      FactoryBot.create_list(:card, 5)
    end
    
    before :each do
      get :index
    end
    
    it 'is expected to have :ok (200) HTTP response code' do
      expect(response.status).to eq(200)
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
  
  describe 'GET #show' do
    context 'with valid params' do
      # 1. Create a global var with Card via FactoryBot
      before :all do
        Card.destroy_all
        @card = FactoryBot.create(:card)
      end
      
      # 2. Add before each with "show" request.
      before :each do
        get :show, params: { id: @card.id }
      end
      
      # 3. Write tests for "response code", "return of correct Card", "presense of fields", "absense of fields".
      it 'is expected to have :ok (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'is expected to return correct Card' do
        json_response = JSON.parse(response.body)
        puts "*"*80
        puts json_response
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
      
      # 4. Move existing tests into "with valid params" context.
      # 5. Write all the tests for "ActiveRecord::RecordNotFound" in context "not found"
    end
  end
end
