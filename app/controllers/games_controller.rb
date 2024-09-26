class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :update, :join]
  before_action :ensure_can_create_game, only: [:new, :create]
  before_action :ensure_can_join_game, only: [:join]

  def index
    @games = Game.where(status: 'waiting')
    @active_game = current_user.active_game
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      GameParticipation.create(user: current_user, game: @game)
      redirect_to @game, notice: 'Game was created. Waiting for other players...'
    else
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
    @participation = current_user.game_participations.find_by(game: @game)

    if @game.status == 'waiting' && @game.users.count >= 2
      @game.update(status: 'in_progress')
      GameChannel.broadcast_to(@game, { action: 'start_game', countdown: 30 })
    end
  end

  def update
    if @game.status == 'in_progress'
      selected_card = params[:selected_card].to_i
      bet_amount = params[:bet_amount].to_i

      participation = current_user.game_participations.find_by(game: @game)
      participation.update(selected_card: selected_card, bet_amount: bet_amount)

      if @game.game_participations.where.not(selected_card: nil).count == @game.users.count
        determine_winner
      end

      head :ok
    else
      head :unprocessable_entity
    end
  end

  def join
    GameParticipation.create(user: current_user, game: @game)
    redirect_to @game, notice: 'You have joined the game.'
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:group_id)
  end

  def ensure_can_create_game
    unless current_user.can_create_game?
      redirect_to games_path, alert: 'You cannot create a new game while you have an active game.'
    end
  end

  def ensure_can_join_game
    unless current_user.can_join_game?(@game)
      redirect_to games_path, alert: 'You cannot join this game while you have an active game.'
    end
  end

  def determine_winner
    winners = @game.game_participations.where(selected_card: @game.winning_card)
    losers = @game.game_participations.where.not(selected_card: @game.winning_card)

    total_pot = losers.sum(&:bet_amount)
    winner_share = winners.any? ? total_pot / winners.count : 0

    winners.each do |winner|
      winner.user.update(c_bucks: winner.user.c_bucks + winner_share)
      GameHistory.create(user: winner.user, game: @game, amount: winner_share, action: 'win')
    end

    losers.each do |loser|
      loser.user.update(c_bucks: loser.user.c_bucks - loser.bet_amount)
      GameHistory.create(user: loser.user, game: @game, amount: loser.bet_amount, action: 'loss')
    end

    @game.update(status: 'completed')

    GameChannel.broadcast_to(@game, {
      action: 'game_result',
      winning_card: @game.winning_card,
      winners: winners.map { |w| { username: w.user.username, winnings: winner_share } },
      losers: losers.map { |l| { username: l.user.username, losses: l.bet_amount } }
    })
  end
end