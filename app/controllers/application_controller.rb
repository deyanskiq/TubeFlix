class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action  :authenticate_user!, :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :role])
  end
end
