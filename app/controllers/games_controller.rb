class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]

  def new
    @game = Game.new
    @games = current_user.games
  end

  def create
    Rails.logger.info "Current user: #{current_user.inspect}"
    Rails.logger.info "Current user's groups: #{current_user.groups.inspect}"

    @group = current_user.groups.first
    Rails.logger.info "Selected group: #{@group.inspect}"

    @game = @group.games.build
    @game.status = 'completed'
    @game.set_winning_card


    if @game.save
      @participation = @game.game_participations.create(
        user: current_user,
        selected_card: params[:game][:selected_card],
        bet_amount: params[:game][:bet_amount]
      )
      @game.update_user_c_bucks  # Make sure this method exists in your Game model
      redirect_to @game, notice: 'Bet placed successfully.'
    else
      Rails.logger.error "Game save failed: #{@game.errors.full_messages}"
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