class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for Game.find(params[:id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end