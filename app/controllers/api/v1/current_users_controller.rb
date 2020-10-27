class Api::V1::CurrentUsersController < ApplicationController
  def update
    # update email (avoid locking out user on typo: change email only when clicked)
  end

  def destroy
    # TODO: delete account
  end
end
