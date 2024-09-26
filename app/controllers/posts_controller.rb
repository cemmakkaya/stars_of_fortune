class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @group, notice: 'Beitrag wurde erfolgreich erstellt.'
    else
      redirect_to @group, alert: 'Fehler beim Erstellen des Beitrags.'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end