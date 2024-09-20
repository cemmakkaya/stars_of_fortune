class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @histories = current_user.game_histories.order(created_at: :desc).limit(10)
  end
end