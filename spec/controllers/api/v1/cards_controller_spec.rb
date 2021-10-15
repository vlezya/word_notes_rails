require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :controller do
  describe 'routing' do
    it 'routes GET /api/v1/cards to api/v1/cards#index' do
      expect(get: '/api/v1/cards').to route_to(controller: 'api/v1/cards',
         action: 'index', format: 'json')
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
end
