class Api::V1::UsersController < ApplicationController
  
  def create
    @user = User.new(user_params)
    if @user.save
      user_json = CardSerializer.new(@user).as_json
      render json: { user: user_json, status: created }
    else
      render json: { status: 404 }
    end
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
