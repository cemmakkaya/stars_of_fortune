class Users::RegistrationsController < Devise::RegistrationsController
  def create
    params[:user].delete(:email)
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end