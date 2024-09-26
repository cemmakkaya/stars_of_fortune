class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:username]

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :game_participations, dependent: :destroy
  has_many :games, through: :game_participations
  has_many :game_histories, dependent: :destroy


  validates :username, presence: true, uniqueness: { case_sensitive: false }

  scope :admins, -> { where(admin: true) }

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

  def admin?
    admin == true
  end
end