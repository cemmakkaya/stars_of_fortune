class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :join, :leave]

  def index
    @groups = Group.all
  end

  def show
    if @group.nil?
      redirect_to groups_path, alert: 'Gruppe wurde aufgrund zu wenig Mitglieder gelöscht.'
    else
      @members_count = @group.users.count
      @is_member = @group.users.include?(current_user)
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users << current_user

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def join
    if @group.users.count < Group::MAX_MEMBERS
      unless @group.users.include?(current_user)
        @group.users << current_user
        redirect_to @group, notice: 'You have joined the group.'
      else
        redirect_to @group, alert: 'You are already a member of this group.'
      end
    else
      redirect_to @group, alert: 'This group has reached its maximum capacity.'
    end
  end

  def leave
    if @group&.users&.include?(current_user)
      @group.users.delete(current_user)
      @group.reload # Stellt sicher, dass die Gruppe neu geladen wird
      if @group.destroyed?
        redirect_to groups_path, notice: 'Sie haben die Gruppe verlassen. Die Gruppe wurde aufgrund zu wenig Mitglieder gelöscht.'
      else
        redirect_to @group, notice: 'Sie haben die Gruppe verlassen.'
      end
    else
      redirect_to groups_path, alert: 'Sie sind kein Mitglied dieser Gruppe oder die Gruppe existiert nicht mehr.'
    end
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end