class AuthToken
  JWT_ALG = 'HS256'.freeze

  def self.encode(payload:, exp:, secret:)
    JWT.encode(payload.merge(exp: exp), secret, JWT_ALG)
  end

  def self.decode(token:, secret:)
    JWT.decode(token, secret, true, algorithm: JWT_ALG)
  end
end
