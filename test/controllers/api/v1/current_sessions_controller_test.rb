require 'test_helper'

class Api::V1::CurrentSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test "should return empty response if user is not logged in" do
    get api_v1_current_session_url, headers: auth_headers

    empty_response = { "user" => nil, "token" => nil }

    assert_response 200
    assert_equal empty_response, json_response
  end

  test "should return session data for logged-in users" do
    sign_in_as(@user)

    get api_v1_current_session_url, headers: auth_headers

    assert_response 200
    assert_session_response(@user.reload)
  end

  test "should log out logged-in users" do
    sign_in_as(@user)
    token = refresh_token(@user)

    delete api_v1_current_session_url, headers: auth_headers

    assert_response 200
    assert_equal ok_response, json_response

    assert Session.find_by_refresh_token(token).revoked?
    assert_nil refresh_token(@user)
  end

  test "log out should be neutral for logged-out users" do
    delete api_v1_current_session_url, headers: auth_headers

    assert_response 200
  end
end
