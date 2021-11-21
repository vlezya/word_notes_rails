class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create
  
  # POST /api/v1/sessions
  def create
    user = User.find_by!(email: user_params[:email])
    
    if !user.authenticate(user_params[:password])
      render json: { errors: user.errors }, status: :unauthorized
      return
    end
    
    session = Session.new(session_params)
    session.user = user
    if session.save
      session_json = SessionSerializer.new(session).as_json
      user_json = UserSerializer.new(user).as_json
      render json: { session: session_json, user: user_json }, status: :created
    else
      render json: { errors: session.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/sessions/:token
  def destroy
    session = Session.find_by!(token: params[:token])
    if session.destroy
      render json: { success: true }, status: :ok
    else
      render json: { errors: session.errors }, status: :unprocessable_entity
    end
  end
  
  private
    def session_params
      params.require(:session).permit(:operational_system)
    end
    
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
