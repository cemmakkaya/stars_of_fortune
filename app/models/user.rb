class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:username]

  has_many :group_memberships
  has_many :groups, through: :group_memberships
  has_many :game_participations
  has_many :games, through: :game_participations
  has_many :game_histories


  validates :username, presence: true, uniqueness: { case_sensitive: false }
  
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def ensure_email
    self.email = "#{SecureRandom.uuid}@example.com" if email.blank?
  end
end