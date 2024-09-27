class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :games, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :maximum_members

  MAX_MEMBERS = 4

  after_create :add_creator_to_group

  def remove_member(user)
    membership = group_memberships.find_by(user_id: user.id)
    if membership
      membership.destroy
      destroy_if_empty
    end
  end

  private

  def maximum_members
    if users.count > MAX_MEMBERS
      errors.add(:base, "Diese Gruppe hat die maximale Kapazität von #{MAX_MEMBERS} Mitgliedern erreicht")
    end
  end

  def add_creator_to_group
    users << User.current if User.current.present?
  end

  def destroy_if_empty
    destroy if users.reload.empty?
  end
end