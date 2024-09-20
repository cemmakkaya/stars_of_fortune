class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :join, :leave]

  def index
    @groups = Group.all
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users << current_user  # Fügt den aktuellen Benutzer als Mitglied hinzu

    if @group.save
      redirect_to @group, notice: 'Gruppe wurde erfolgreich erstellt.'
    else
      render :new
    end
  end

  def join
    unless current_user.groups.include?(@group)
      current_user.groups << @group
      redirect_to @group, notice: 'You have joined the group.'
    else
      redirect_to @group, alert: 'You are already a member of this group.'
    end
  end

  def leave
    if current_user.groups.include?(@group)
      current_user.groups.delete(@group)
      redirect_to groups_path, notice: 'You have left the group.'
    else
      redirect_to groups_path, alert: 'You are not a member of this group.'
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end