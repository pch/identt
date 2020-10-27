class Api::V1::CurrentSessionsController < ApplicationController
  # Returns current session (with user and access token)
  #
  # If user is not logged in it will return an empty 200 response,
  # rather than throwing a 401. It's not actually an error when user
  # is logged out.
  #
  # This endpoint intended to be called whenever we need to check
  # if user is logged in (it returns auth token for subsequent requests).
  def show
    render_session_json
  end

  # Revokes the current session, logs current user out.
  def destroy
    cookies.delete(cookie_key)

    if Current.session
      Current.session.revoke!
      UserAction.track!(action: "logged_out")
      Current.session = nil
    end

    render_ok
  end
end
