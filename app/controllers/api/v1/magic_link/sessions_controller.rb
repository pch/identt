class Api::V1::MagicLink::SessionsController < ApplicationController
  def request_link
    @user = client_app.users.by_insensitive_email(params[:email].to_s)

    if @user
      SendMagicLink.call(@user)
      render_ok
    else
      render_error({ email: [ErrorCodes::SESSION_INVALID_EMAIL] }, :unprocessable_entity)
    end
  end

  def create
    @user = client_app.users.find_by_encoded_magic_login_token(params[:token].to_s, client_app)

    if @user
      LogInUser.call(@user)

      render_session_json status: :created
    else
      render_error credentials: [ErrorCodes::SESSION_INVALID_MAGIC_LOGIN_TOKEN]
    end
  end
end
