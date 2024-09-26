class Group < ApplicationRecord
  # Using only one association for users through memberships
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :games, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :maximum_members

  MAX_MEMBERS = 4

  after_create :add_creator_to_group

  # Method to remove a member (you might want this)
  def remove_member(user)
    group_memberships.find_by(user_id: user.id)&.destroy
  end

  private

  def maximum_members
    if users.count > MAX_MEMBERS
      errors.add(:base, "Diese Gruppe hat die maximale Kapazität von #{MAX_MEMBERS} Mitgliedern erreicht")
    end
  end

  def add_creator_to_group
    # Assuming you will handle adding the creator in the controller
    if User.current.present?
      users << User.current
    end
  end
end
