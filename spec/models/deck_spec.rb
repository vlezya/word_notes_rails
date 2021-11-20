require 'rails_helper'

RSpec.describe Deck, type: :model do
  it 'is expected to have a valid factory' do
    user = FactoryBot.create(:user)
    deck = FactoryBot.build(:deck, user: user)
    expect(deck.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to have_and_belong_to_many(:cards) }
    it { is_expected.to belong_to(:user).required }
  end
  
  context 'validations' do
    context 'associations' do
    end
    context 'fields' do
      it { is_expected.to validate_presence_of(:title) }
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
  end
end
