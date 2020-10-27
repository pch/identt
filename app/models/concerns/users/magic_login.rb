module Users::MagicLogin
  extend ActiveSupport::Concern

  MAGIC_LOGIN_TOKEN_LENGTH = 16
  MAGIC_LOGIN_TOKEN_TTL    = 1.hour

  module ClassMethods
    def find_by_encoded_magic_login_token(token, client_app)
      decoded_token, _ = AuthToken.decode(token: token, secret: client_app.api_secret)
      find_by(magic_login_token: decoded_token.fetch("t"))
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::VerificationError
      # TODO: log events like this
      nil
    end
  end

  def generate_magic_login_token
    self.magic_login_token = SecureRandom.urlsafe_base64(MAGIC_LOGIN_TOKEN_LENGTH)
    save!
  end

  def erase_magic_login_token
    update_column(:magic_login_token, nil)
  end

  def signed_magic_login_token
    raise "Magic login token is empty" if magic_login_token.blank?

    AuthToken.encode(payload: { t: magic_login_token }, exp: MAGIC_LOGIN_TOKEN_TTL.from_now.to_i, secret: client_app.api_secret)
  end
end
