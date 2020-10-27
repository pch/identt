class SignUpUserWithEmail < ApplicationService
  def initialize(params, client_app)
    @email = params[:email]
    @client_app = client_app
  end

  def call
    existing_user = @client_app.users.find_by_email(@email) if @email.present?
    return existing_user if existing_user

    new_user = @client_app.users.build(email: @email)
    new_user.assign_random_password

    new_user.save
    new_user
  end
end
