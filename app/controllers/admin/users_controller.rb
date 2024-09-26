module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = User.all
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully deleted.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :admin, :c_bucks)
    end

    def require_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
    end
  end
end