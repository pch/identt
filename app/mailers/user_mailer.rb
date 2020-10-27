class UserMailer < ApplicationMailer
  def magic_link(user, callback_url)
    @user = user
    @callback_url = callback_url

    mail to: user.email, subject: "Sign in"
  end
end
