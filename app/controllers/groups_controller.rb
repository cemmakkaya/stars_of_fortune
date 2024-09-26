class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
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
    @group = Group.find(params[:id])
    current_user.groups << @group unless current_user.groups.include?(@group)
    redirect_to @group, notice: 'You have joined the group.'
  end

  def leave
    @group = Group.find(params[:id])
    current_user.groups.delete(@group)
    redirect_to groups_url, notice: 'You have left the group.'
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end