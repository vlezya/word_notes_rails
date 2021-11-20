require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'is expected to have a valid factory' do
    user = FactoryBot.create(:user)
    card = FactoryBot.build(:card, user: user)
    expect(card.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to have_and_belong_to_many(:decks) }
    it { is_expected.to belong_to(:user).required }
  end
  
  context 'validations' do
    context 'associations' do
    end
    context 'fields' do
      it { is_expected.to validate_presence_of(:word) }
      it { is_expected.to validate_presence_of(:translation) }
      it { is_expected.to validate_presence_of(:example) }
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
  end
end
