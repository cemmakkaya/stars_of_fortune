class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]

  def new
    @game = Game.new
  end

  def create
    @game = current_user.groups.first.games.build
    @game.status = 'completed'  # Set the game as completed immediately
    @game.set_winning_card  # Make sure this method exists in your Game model

    if @game.save
      @participation = @game.game_participations.create(
        user: current_user,
        selected_card: params[:game][:selected_card],
        bet_amount: params[:game][:bet_amount]
      )
      @game.update_user_c_bucks  # Make sure this method exists in your Game model
      redirect_to @game, notice: 'Bet placed successfully.'
    else
      render :new
    end
  end

  def show
    @participation = @game.game_participations.find_by(user: current_user)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:selected_card, :bet_amount)
  end
end