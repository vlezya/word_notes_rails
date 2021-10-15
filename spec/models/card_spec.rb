require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'should have a valid factory' do
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

  # subject {
  #   described_class.new(word:"test", 
  #     translation: "тест", 
  #     example: "How to Test Rails Models with RSpec")
  #  }

  #  context "validation" do
  #   it "is valid with valid attributes" do
  #     expect(subject).to be_valid
  #   end

  #   it "is not valid without a word" do
  #     subject.word = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it "is not valid without a translation" do
  #     subject.translation = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it "is not valid without an example" do
  #     subject.example = nil
  #     expect(subject).to_not be_valid
  #   end
  # end
end
