class Session < ApplicationRecord
  SESSION_TTL = 6.months
  ACCESS_TOKEN_TTL = 1.hour

  include RandomToken

  belongs_to :client_app
  belongs_to :user

  before_create { generate_base58_token(:identifier) }
  before_create { generate_base64_token(:refresh_token) }

  scope :active, -> { where(revoked_at: nil).where('expires_at > ?', Time.now) }

  def self.create_new_session!(user)
    create! \
      user: user,
      client_ip: Current.client_ip,
      user_agent: Current.user_agent,
      accessed_at: Time.now,
      expires_at: SESSION_TTL.from_now
  end

  def self.authenticate_with_refresh_token(refresh_token)
    session = active.find_by_refresh_token(refresh_token)
    session&.log_access
    session
  end

  def self.empty_response
    { user: nil, token: nil }
  end

  def as_json
    {
      token: {
        access_token: access_token,
        expires_in: ACCESS_TOKEN_TTL
      },
      user: user.as_json
    }
  end

  def access_token
    AuthToken.encode(payload: user.as_token_json, exp: ACCESS_TOKEN_TTL.from_now.to_i, secret: client_app.api_secret)
  end

  def log_access
    update_column(:accessed_at, Time.now)
  end

  def revoke!
    update_column(:revoked_at, Time.now)
  end

  def revoked?
    revoked_at.present?
  end
end
