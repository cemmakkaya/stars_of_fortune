class Admin::DashboardController < ApplicationController
  def index
    @users = User.all
    @groups = Group.all
    @new_group = Group.new
  end

  def create_group
    @group = Group.new(group_params)
    if @group.save
      redirect_to admin_dashboard_path, notice: 'Gruppe erfolgreich erstellt.'
    else
      @users = User.all
      @groups = Group.all
      render :index
    end
  end

  def update_group
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_dashboard_path, notice: 'Gruppe erfolgreich aktualisiert.'
    else
      @users = User.all
      @groups = Group.all
      @new_group = Group.new
      render :index
    end
  end

  def destroy_group
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_dashboard_path, notice: 'Gruppe erfolgreich gelöscht.'
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end