class LogInUser < ApplicationService
  def initialize(user)
    @user = user
    @client_app = user.client_app
  end

  def call
    @user.erase_magic_login_token
    @user.confirm_email

    create_session_for!(@user)
  end

  private

    def create_session_for!(user)
      unless Current.session
        Current.session = @client_app.sessions.create_new_session!(user)
        UserAction.track!(action: "logged_in")
      end
    end
end
