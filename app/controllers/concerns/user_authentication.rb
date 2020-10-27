module UserAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_refresh_token
    after_action  :set_refresh_token_cookie
  end

  private

    def authenticate_with_refresh_token
      return if refresh_token.blank?

      Current.session = Session.authenticate_with_refresh_token(refresh_token)
    end

    # Refresh token should be passed in a cookie
    def refresh_token
      return @refresh_token if defined? @refresh_tokeh

      @refresh_token = cookies.encrypted[cookie_key]
    end

    def require_authentication!
      return if Current.session

      render_error refresh_token: [ErrorCodes::AUTH_INVALID_OR_MISSING_REFRESH_TOKEN]
    end

    def render_session_json(status: :ok)
      render json: Current.session&.as_json || Session.empty_response, status: status
    end

    def set_refresh_token_cookie
      return unless Current.session

      cookies.encrypted[cookie_key] = {
        value: Current.session.refresh_token,
        httponly: true,
        secure: Rails.env.production?,
        expires: Session::SESSION_TTL
      }
    end

    def cookie_key
      :"#{client_app.identifier}_auth"
    end
end
