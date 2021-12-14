require 'rails_helper'

RSpec.describe CardDeck, type: :model do
  it 'is expected to have a valid factory' do
    user = FactoryBot.create(:user)
    deck = FactoryBot.create(:deck, user: user)
    card = FactoryBot.create(:card, user: user)
    card_deck = FactoryBot.build(:card_deck, card_id: card.id, deck_id: deck.id)
    
    expect(card_deck.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:card).required }
    it { is_expected.to belong_to(:deck).required }
  end
  
  context 'validations' do
    context 'associations' do
    end
    context 'fields' do
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
  end
end
