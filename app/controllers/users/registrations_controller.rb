class Users::RegistrationsController < Devise::RegistrationsController
  def create
    params[:user].delete(:email)
    super do |user|
      user.c_bucks = 500 if user.persisted?
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end