class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # handles unautorized errors and show message on the current page
  # rescue_from CanCan::AccessDenied do |exception|
  #   respond_to do |format|
  #     format.json {head :forbidden}
  #     format.html {redirect_to main_app.root_url, :alert => exception.message}
  #   end
  # end
  #
    rescue_from CanCan::AccessDenied do |exception|
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    end


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :role])
  end
end
