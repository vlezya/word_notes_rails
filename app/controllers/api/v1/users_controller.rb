class Api::V1::UsersController < ApiController
  skip_before_action :authenticate
  
  # POST /api/v1/users
  def create
    user = User.new(user_params)
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
  
  private
    def session_params
      params.require(:session).permit(:operational_system)
    end
    
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
