require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'is expected to have a valid factory' do
    card = FactoryBot.build(:card)
    expect(card.valid?).to eq(true)
  end
  
  context 'associations' do
  end
  
  context 'validations' do
    context 'associations' do
    end
    context 'fields' do
      subject { FactoryBot.build(:card) }
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
