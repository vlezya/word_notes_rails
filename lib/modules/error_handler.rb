module ErrorHandler
  class ActionForbidden < StandardError
  end
  
  def self.included(base)
    base.class_eval do
      rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: { errors: { base: 'Record not found'} }, status: :not_found
      end
      
      rescue_from ActionForbidden do |exception|
        render json: { errors: { base: 'Action is forbidden' } }, status: :forbidden
      end
    end
  end
end
