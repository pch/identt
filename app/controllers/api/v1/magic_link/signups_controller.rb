class Api::V1::MagicLink::SignupsController < ApplicationController
  def create
    @user = SignUpUserWithEmail.call(user_params, client_app)
    if @user && @user.persisted?
      SendMagicLink.call(@user)
      render_ok
    else
      render_error @user.errors, :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end
end
