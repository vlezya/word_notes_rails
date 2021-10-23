class Api::V1::UsersController < ApplicationController
  
  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      user_json = UserSerializer.new(@user).as_json
      render json: { user: user_json }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
