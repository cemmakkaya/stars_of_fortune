class GameHistory < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :amount, presence: true
  validates :action, presence: true, inclusion: { in: ['win', 'loss'] }
end