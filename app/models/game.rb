class Game < ApplicationRecord
  belongs_to :group
  has_many :game_participations
  has_many :users, through: :game_participations
  has_many :game_histories

  attribute :cards, :json, default: -> { (1..4).to_a.shuffle }
  attribute :winning_card, :integer
  attribute :status, :string, default: 'waiting'
  attribute :start_time, :datetime

  before_create :setup_game

  def start_countdown
    update(start_time: Time.current + 15.seconds)
  end

  def time_left
    return 0 if start_time.nil?
    [(start_time - Time.current).to_i, 0].max
  end

  def ready_to_start?
    users.count >= 2 && time_left == 0
  end

  private

  def setup_game
    self.winning_card = cards.first
  end
end