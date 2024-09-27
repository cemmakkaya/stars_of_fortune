class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :authenticate_user!

  def index
    @groups = Group.all
  end

  def show
    @members_count = @group.users.count
    @is_member = @group.users.include?(current_user)
    @post = Post.new  # Initialisiere @post hier
  end
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    Group.transaction do
      if @group.save
        @group.users << current_user
        redirect_to @group, notice: 'Gruppe wurde erfolgreich erstellt und Sie sind beigetreten.'
      else
        render :new
      end
    end
  rescue ActiveRecord::RecordInvalid
    @group.errors.add(:base, "Fehler beim Erstellen der Gruppe")
    render :new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def join
    if @group.nil?
      redirect_to groups_path, alert: 'Gruppe nicht gefunden.'
    elsif @group.users.include?(current_user)
      redirect_to @group, alert: 'Sie sind bereits Mitglied dieser Gruppe.'
    else
      @group.users << current_user
      redirect_to @group, notice: 'Sie sind der Gruppe beigetreten.'
    end
  end
  def leave
    if @group.users.include?(current_user)
      @group.remove_member(current_user)
      if @group.destroyed?
        redirect_to groups_path, notice: 'Sie haben die Gruppe verlassen. Die Gruppe wurde gelöscht, da sie keine Mitglieder mehr hatte.'
      else
        redirect_to groups_path, notice: 'Sie haben die Gruppe verlassen.'
      end
    else
      redirect_to groups_path, alert: 'Sie sind kein Mitglied dieser Gruppe.'
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def ensure_member
    @is_member = @group.users.include?(current_user)
    unless @is_member
      flash.now[:alert] = 'Sie müssen der Gruppe beitreten, um Posts zu erstellen.'
    end
  end
end