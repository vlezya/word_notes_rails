require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is expected to have a valid factory' do
    user = FactoryBot.build(:user)
    expect(user.valid?).to eq(true)
  end
  
  context 'associations' do
  end
  
  context 'validations' do
    context 'associations' do
    end
    
    context 'fields' do
      subject { FactoryBot.build(:user) }
      
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      
      context '#create' do
        subject { User.new(FactoryBot.attributes_for(:user).except(:password, :password_confirmation)) }
        
        it { is_expected.to validate_presence_of(:password) }
        it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(72) }
        it { is_expected.to validate_confirmation_of(:password) }
      end
      
      context '#update' do
        it 'is expected to NOT require :password for update' do
          user = FactoryBot.create(:user)
          expect(user.update(email: Faker::Internet.email)).to eq(true)
        end
      end
    end
  end
  
  context 'normalization' do
    it 'is expected to normalize :email field' do
      user = FactoryBot.build(:user, email: ' CiA123@go.HOME ')
      expect(user.email).to eq('cia123@go.home')
    end
  end
  
  context 'callbacks' do
  end
end
