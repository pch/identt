class User < ApplicationRecord
  include RandomToken
  include Users::Validations
  include Users::MagicLogin

  belongs_to :client_app

  has_many :sessions
  has_many :user_actions

  # Password-login is curently unsupported, but kept for legacy reasons
  has_secure_password validations: false
  attr_accessor :current_password

  before_create { generate_base58_token(:identifier, 16) }

  # Users who never logged in should be ignored by client apps
  scope :unconfirmed, -> { where(email_confirmed: false) }

  def self.by_insensitive_email(email)
    where("lower(email) = ?", email.downcase).first
  end

  def as_json(options = {})
    super({ only: [:identifier, :email, :email_confirmed] }.merge(options))
  end

  def as_token_json
    as_json({ only: [:identifier, :email] })
  end

  def assign_random_password
    self.password = SecureRandom.urlsafe_base64
  end

  def confirm_email
    update_column(:email_confirmed, true) unless email_confirmed?
  end
end
