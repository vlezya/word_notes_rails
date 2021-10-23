class Api::V1::SessionsController < ApplicationController
  
  # POST /api/v1/sessions
  def create
    # 1. params[:user] -> move to strong parameters (for User)
    # 2. Generate Session model (token:string, user_id:bigint)
    # 3. On Session model creation token should be set to a random unique value
    # 4. `token` field should not be changed on session#update
    # 5. Cover Session model with tests, including associations
    
    user = User.find_by!(email: params[:user][:email])
    
    if user.authenticate(params[:user][:password])
      # Create Session object, associate it with User, serialize and return both User and Session objects back
      render json: { success: true }, status: :created
    else
      render json: { success: false }, status: :unauthorized
    end
  end
  
  # DELETE /api/v1/sessions/:id
  def destroy
  end
end
