require 'rails_helper'

RSpec.describe Deck, type: :model do
  before(:all) do
    @deck = FactoryBot.create(:deck)
  end
  
  it 'is expected to have a valid factory' do
    expect(@deck.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to have_and_belong_to_many(:cards) }
  end
  
  context 'validations' do
    context 'associations' do
    end
    context 'fields' do
      subject { FactoryBot.build(:deck) }
      it { is_expected.to validate_presence_of(:title) }
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
  end

end
