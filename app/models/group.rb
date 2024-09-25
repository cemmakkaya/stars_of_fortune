class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships, after_remove: :destroy_if_empty
  has_many :games, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :maximum_members

  MAX_MEMBERS = 4

  private

  def maximum_members
    if users.count >= MAX_MEMBERS
      errors.add(:base, "Diese Gruppe hat die maximale Kapazität von #{MAX_MEMBERS} Mitgliedern erreicht")
    end
  end

  def destroy_if_empty(_user = nil)
    destroy if users.reload.empty?
  end
end