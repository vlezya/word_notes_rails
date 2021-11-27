class ApplicationController < ActionController::API
  include ErrorHandler
  include Pundit
  before_action :authenticate
  
  def current_user
    @current_user
  end
  
  private
    def authenticate
      # Check Session token presence
      token = request.headers['X-Session-Token']
      if token.nil?
        render json: { errors: ['No access token in header'] }, status: :unauthorized
        return
      end
      
      # Check if Device with this token exists
      current_session = Session.find_by(token: token)
      if current_session.nil?
        render json: { errors: ['Invalid Session'] }, status: :unauthorized
        return
      end
      
      @current_user = current_session.user
    end
end
