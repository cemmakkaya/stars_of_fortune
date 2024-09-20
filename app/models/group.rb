class Group < ApplicationRecord
  has_many :group_memberships
  has_many :users, through: :group_memberships
  has_many :games
  
  validates :name, presence: true, uniqueness: true
end