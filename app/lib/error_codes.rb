class ErrorCodes
  AUTH_INVALID_OR_MISSING_API_KEY = "auth.invalid_or_missing_api_key".freeze
  AUTH_INVALID_OR_MISSING_API_SIGNATURE = "auth.invalid_or_missing_api_signature".freeze

  AUTH_INVALID_OR_MISSING_REFRESH_TOKEN = "auth.invalid_or_missing_refresh_token".freeze

  SESSION_INVALID_EMAIL = "session.invalid_email".freeze
  SESSION_INVALID_MAGIC_LOGIN_TOKEN = "sessions.invalid_magic_login_token".freeze

  SIGNUP_EMAIL_MISSING = "signup.email_missing".freeze
  SIGNUP_PASSWORD_MISSING   = "signup.password_missing".freeze
  SIGNUP_PASSWORD_TOO_SHORT = "signup.password_too_short".freeze
  SIGNUP_PASSWORD_TOO_LONG  = "signup.password_too_long".freeze
  SIGNUP_PASSWORD_NOT_CONFIRMED = "signup.password_not_confirmed".freeze
  SIGNUP_EMAIL_ALREADY_TAKEN  = "signup.email_already_taken".freeze
  SIGNUP_EMAIL_INVALID_FORMAT = "signup.email_invalid_format".freeze
end
