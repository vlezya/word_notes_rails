require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'routing' do
    it 'routes POST /api/v1/sessions to api/v1/sessions#create' do
      expect(post: 'api/v1/sessions').to route_to(
        controller: 'api/v1/sessions',
        action: 'create',
        format: 'json'
      )
    end
    
    it 'routes DELETE api/v1/sesions/:token to api/v1/sesions#destroy' do
      expect(delete: 'api/v1/sessions/sBhjhf23jgsad').to route_to(
        controller: 'api/v1/sessions',
        action: 'destroy',
        token: 'sBhjhf23jgsad',
        format: 'json'
      )
    end
  end
  
  before :all do
    @password = 'TestPass$1234'
    @user = FactoryBot.create(:user, password: @password, password_confirmation: @password)
    @session = FactoryBot.create(:session, user: @user)
  end
  
  describe 'POST #create' do
    context 'with valid password' do
      before :each do
        @users_before_request = User.count
        @sessions_before_request = Session.count
        
        user_params = {
          email: @user.email,
          password: @password
        }
        session_params = {
          operational_system: Session::OPERATIONAL_SYSTEMS.sample
        }
        
        post :create, params: { user: user_params, session: session_params }
      end
      
      it 'is expected to have :created (201) HTTP response code' do
        expect(response.status).to eq(201)
      end
      
      it 'expected return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected NOT to create a new User' do
        expect(User.count).to eq(@users_before_request)
      end
      
      it 'is expected to create a new Session' do
        expect(Session.count).to eq(@sessions_before_request + 1)
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
    
    context 'with INVALID password' do
      before :each do
        invalid_password = 'test2133$sda'
        @users_before_request = User.count
        @sessions_before_request = Session.count
        
        user_params = {
          email: @user.email,
          password: invalid_password
        }
        session_params = {
          operational_system: Session::OPERATIONAL_SYSTEMS.sample
        }
        
        post :create, params: { user: user_params, session: session_params }
      end
      
      it 'is expected to have :unauthorized (401) HTTP response code' do
        expect(response.status).to eq(401)
      end
      
      it 'is expected NOT to create a new User' do
        expect(User.count).to eq(@users_before_request)
      end
      
      it 'is expected NOT to create a new Session' do
        expect(Session.count).to eq(@sessions_before_request)
      end
    end
    
    context 'with INVALID email' do
      before :each do
        user = FactoryBot.create(:user)
        @users_before_request = User.count
        @sessions_before_request = Session.count
        
        user_params = {
          email: user.email,
          password: @password
        }
        session_params = {
          operational_system: Session::OPERATIONAL_SYSTEMS.sample
        }
        
        post :create, params: { user: user_params, session: session_params }
      end
      
      it 'is expected to have :unauthorized (401) HTTP response code' do
        expect(response.status).to eq(401)
      end
      
      it 'expected return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected NOT to create a new Session' do
        expect(Session.count).to eq(@sessions_before_request)
      end
      
      it 'is expected to return errors' do
        json_response = JSON.parse(response.body)
        expect(json_response.key?('errors')).to eq(true)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'with valid params' do
      before(:each) do
        user = FactoryBot.create(:user)
        session = FactoryBot.create(:session, user: user)
        @sessions_before_request = Session.count
        
        request.headers['X-Session-Token'] = @session.token
        delete :destroy, params: { token: session.token }
      end
      
      it 'is expected to have :destroy (200) HTTP response code' do
        expect(response.status).to eq(200)
      end
      
      it 'expected return application/json content type' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
      
      it 'is expected to delete a Session' do
        expect(Session.count).to eq(@sessions_before_request - 1)
      end
    end
  end
end
