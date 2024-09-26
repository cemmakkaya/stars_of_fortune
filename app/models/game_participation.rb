class GameParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :selected_card, presence: true, inclusion: { in: 1..4 }
  validates :bet_amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: ->(gp) { gp.user.c_bucks } }
end