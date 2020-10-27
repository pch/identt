class SendMagicLink < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    @user.generate_magic_login_token

    action = @user.email_confirmed? ? "login" : "signup"
    callback_url = @user.client_app.callback_url(token: @user.signed_magic_login_token, action: action)

    UserMailer.magic_link(@user, callback_url).deliver_later
  end
end
