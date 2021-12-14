require 'rails_helper'

RSpec.describe CardDeck, type: :model do
  it 'is expected to have a valid factory' do
    user = FactoryBot.create(:user)
    deck = FactoryBot.create(:deck, user: user)
    card = FactoryBot.create(:card, user: user)
    card_deck = FactoryBot.build(:card_deck, card: card, deck: deck)
    
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
      it { is_expected.to validate_uniqueness_of(:deck_id).scoped_to(:card_id)}
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
  end
end
