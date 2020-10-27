module Users::Validations
  extend ActiveSupport::Concern

  MIN_PASSWORD_LENGTH = 6
  MAX_PASSWORD_LENGTH = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  included do
    # This ensures the model has a password by checking whether the password_digest
    # is present, so that this works with both new and existing records. However,
    # when there is an error, the message is added to the password attribute instead
    # so that the error message will make sense to the end-user.
    validate do |record|
      record.errors.add(:password, ErrorCodes::SIGNUP_PASSWORD_MISSING) unless record.send("password_digest").present?
    end

    validates_length_of :password, maximum: MAX_PASSWORD_LENGTH,
                                   minimum: MIN_PASSWORD_LENGTH,
                                   too_short:   ErrorCodes::SIGNUP_PASSWORD_TOO_SHORT,
                                   too_long:    ErrorCodes::SIGNUP_PASSWORD_TOO_LONG,
                                   allow_blank: true

    validates_confirmation_of :password, message: ErrorCodes::SIGNUP_PASSWORD_NOT_CONFIRMED, allow_blank: true

    validates_presence_of   :email, message: ErrorCodes::SIGNUP_EMAIL_MISSING
    validates_uniqueness_of :email, message: ErrorCodes::SIGNUP_EMAIL_ALREADY_TAKEN,  case_sensitive: false, scope: :client_app_id
    validates_format_of     :email, message: ErrorCodes::SIGNUP_EMAIL_INVALID_FORMAT, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true
  end
end
