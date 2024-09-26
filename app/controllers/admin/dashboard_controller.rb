module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      # Add any dashboard logic here
    end

    private

    def require_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
    end
  end
end