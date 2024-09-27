class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :ensure_member

  def create
    @post = @group.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @group, notice: 'Beitrag wurde erfolgreich erstellt.'
    else
      redirect_to @group, alert: 'Fehler beim Erstellen des Beitrags.'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def ensure_member
    unless @group.users.include?(current_user)
      redirect_to @group, alert: 'Sie müssen Mitglied der Gruppe sein, um Posts zu erstellen.'
    end
  end
end