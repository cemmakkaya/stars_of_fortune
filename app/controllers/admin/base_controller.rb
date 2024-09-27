class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "Sie haben keine Berechtigung für diese Seite."
      redirect_to root_path
    end
  end
end