class Api::V1::SessionsController < ApplicationController
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      render json: { status: created }
    else
      render json: { status: 401 }
    end
  end
  
  def destroy
    
  end
  
  def log_in(user)
    session[:user_id] = user.id
  end
end
