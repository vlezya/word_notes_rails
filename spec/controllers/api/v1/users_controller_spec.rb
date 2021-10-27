require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  
  describe 'routing' do
    it 'routes POST api/v1/users to api/v1/users#create' do
      expect(post: 'api/v1/users').to route_to(
        controller: 'api/v1/users',
        action: 'create',
        format: 'json'
      )
    end
  end
  
  describe 'POST #create' do
    context 'with valid params' do
      before do
        @users_before_request = User.count
        @user_params = FactoryBot.attributes_for(:user)
        @session_params = FactoryBot.attributes_for(:session)
        post :create, params: { user: @user_params, session: @session_params }
      end
      
      it 'is expected to have :created (201) HTTP response status code' do
        expect(response.status).to eq(201)
      end
      
      it 'is expected return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to create a new User' do
        expect(User.count).to eq(@users_before_request + 1)
      end
      
      it 'is expected to include User fields' do
        user = JSON.parse(response.body)['user']
        expect(user.key?('id')).to eq(true)
        expect(user.key?('email')).to eq(true)
      end
      
      it 'is expected to NOT include User fields' do
        user = JSON.parse(response.body)['user']
        expect(user.key?('password')).to eq(false)
        expect(user.key?('password_confirmation')).to eq(false)
        expect(user.key?('password_digest')).to eq(false)
        expect(user.key?('created_at')).to eq(false)
        expect(user.key?('updated_at')).to eq(false)
      end
      
      it 'is expected to include Session fields' do
        session = JSON.parse(response.body)['session']
        expect(session.key?('id')).to eq(true)
        expect(session.key?('token')).to eq(true)
        expect(session.key?('user_id')).to eq(true)
      end
      
      it 'is expected to NOT include Session fields' do
        user = JSON.parse(response.body)['session']
        expect(session.key?('created_at')).to eq(false)
        expect(session.key?('updated_at')).to eq(false)
        expect(session.key?('operational_system')).to eq(false)
      end
    end
    
    context 'with INVALID params' do
    end
  end
end
