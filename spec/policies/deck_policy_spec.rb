require 'rails_helper'

describe DeckPolicy do
  before :all do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @card1 = FactoryBot.create(:card, user: @user1)
    @card2 = FactoryBot.create(:card, user: @user2)
    @deck1 = FactoryBot.create(:deck, user: @user1)
    @deck2 = FactoryBot.create(:deck, user: @user2)
    FactoryBot.create(:card_deck, card: @card1, deck: @deck1)
    FactoryBot.create(:card_deck, card: @card1, deck: @deck2)
  end
  
  context 'User is owner' do
    subject { described_class.new(@user1, @deck1) }
    
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
  
  context 'User is NOT owner' do
    subject { described_class.new(@user2, @deck1) }
    
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
