class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::HttpAuthentication::Token
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include SetCurrentRequestDetails
  include ClientAppAuthentication
  include UserAuthentication

  private

    def render_ok
      render json: { result: "ok" }
    end

    def render_error(errors, status=:unauthorized)
      render json: { errors: errors }, status: status
    end
end
