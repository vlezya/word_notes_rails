require 'rails_helper'

describe CardDeckPolicy do
  before :all do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @card1 = FactoryBot.create(:card, user: @user1)
    @deck1 = FactoryBot.create(:deck, user: @user1)
    @deck2 = FactoryBot.create(:deck, user: @user2)
    @card_deck1 = FactoryBot.create(:card_deck, card: @card1, deck: @deck1)
    @card_deck2 = FactoryBot.create(:card_deck, card: @card1, deck: @deck2)
  end
  
  context 'User is owner' do
    subject { described_class.new(@user1, @card_deck1) }
    
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end
  
  context 'User is NOT owner' do
    subject { described_class.new(@user1, @card_deck2) }
    
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
