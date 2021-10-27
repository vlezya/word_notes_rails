require 'rails_helper'

RSpec.describe Session, type: :model do
  before :all do
    @user = FactoryBot.create(:user)
  end
  
  it 'is expected to have a valid factory' do
    session = FactoryBot.build(:session, user: @user)
    expect(session.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:user).required }
  end
  
  context 'validations' do
    context 'associations' do
    end
    
    context 'fields' do
      subject { FactoryBot.build(:session, user: @user) }
      it { is_expected.to validate_presence_of(:operational_system) }
      it { is_expected.to validate_inclusion_of(:operational_system).in_array(Session::OPERATIONAL_SYSTEMS) }
    end
  end
  
  context 'normalization' do
  end
  
  context 'callbacks' do
    context '#create' do
      it 'is expected to assign :token on create' do
        session = FactoryBot.create(:session, user: @user)
        expect(session.token).not_to eq(nil)
      end
    end
    
    context '#update' do
      it 'is expected to assign :token on create' do
        session = FactoryBot.create(:session, user: @user)
        old_token = session.token
        session.update(updated_at: DateTime.current)
        session.reload
        expect(session.token).to eq(old_token)
      end
    end
  end
end
