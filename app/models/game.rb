class Game < ApplicationRecord
  belongs_to :group
  has_many :game_participations
  has_many :users, through: :game_participations
  has_many :game_histories

  attribute :cards, :json, default: []

  before_create :setup_game

  private

  def setup_game
    self.cards = (1..6).to_a.shuffle
    self.winning_card = self.cards.first
    self.status = 'waiting'
  end
end