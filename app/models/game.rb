class Game < ApplicationRecord
  belongs_to :group
  has_many :game_participations
  has_many :users, through: :game_participations
  has_many :game_histories

  def set_winning_card
    self.winning_card = rand(1..4)
  end

  def won?(user)
    participation = game_participations.find_by(user: user)
    participation&.selected_card == winning_card
  end

  def update_user_c_bucks
    game_participations.each do |participation|
      if won?(participation.user)
        participation.user.increment!(:c_bucks, participation.bet_amount)
        create_game_history(participation.user, participation.bet_amount, 'win')
      else
        participation.user.decrement!(:c_bucks, participation.bet_amount)
        create_game_history(participation.user, participation.bet_amount, 'loss')
      end
    end
  end

  private

  def create_game_history(user, amount, action)
    game_histories.create(user: user, amount: amount, action: action)
  end
end