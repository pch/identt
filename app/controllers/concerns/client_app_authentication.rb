module ClientAppAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :require_client_app_api_key!
  end

  private

    def require_client_app_api_key!
      return if client_app

      render_error api_key: [ErrorCodes::AUTH_INVALID_OR_MISSING_API_KEY]
    end

    def client_app
      return @client_app if defined? @client_app

      @client_app ||= ClientApp.find_by_api_key(api_key_header) if api_key_header.present?
    end

    # Requests to certain resources (privileged access) have to be signed
    # with api_secret for additional security.
    #
    # These type of requests will be performend by backends, e.g.:
    #   * list all users
    #   * list user actions
    def require_client_app_signature!
      if api_signature_header.present? && api_timestamp_header.present? && api_timestamp_fresh?
        return if valid_signature?
      end

      render_error api_signature: [ErrorCodes::AUTH_INVALID_OR_MISSING_API_SIGNATURE]
    end

    def api_key_header
      request.headers['X-Api-Key']
    end

    def api_signature_header
      request.headers['X-Api-Signature']
    end

    def api_timestamp_header
      request.headers['X-Api-Timestamp']
    end

    def api_timestamp_fresh?
      Time.now.to_i - api_timestamp_header.to_i > 2.minutes
    end

    def valid_signature?
      str_to_sign = "#{request.method}#{request.original_url}#{api_timestamp_header}"
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), app.api_secret, str_to_sign)

      Rack::Utils.secure_compare(signature, api_signature_header)
    end
end
