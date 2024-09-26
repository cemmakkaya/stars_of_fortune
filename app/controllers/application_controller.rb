class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :reload_current_user, if: :user_signed_in?

  private

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You must be an admin to access this page."
      redirect_to root_path
    end
  end

  def reload_current_user
    current_user.reload
  end
end