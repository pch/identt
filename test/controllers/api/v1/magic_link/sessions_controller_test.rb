require 'test_helper'

class Api::V1::MagicLink::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test "should throw 401 on missing api key" do
    post api_v1_magic_link_sessions_url, params: { email: "foo" }

    assert_response 401
    assert_equal error_response("api_key" => ["auth.invalid_or_missing_api_key"]), json_response
  end

  test "request for magic link should respond with error if user doesn't exist" do
    post request_link_api_v1_magic_link_sessions_url, params: { email: "non-existent@example.com" }, headers: auth_headers

    assert_response 422
    assert_equal error_response("email" => ["session.invalid_email"]), json_response
  end

  test "request for magic link should send email" do
    SendMagicLink.expects(:call)

    post request_link_api_v1_magic_link_sessions_url, params: { email: @user.email }, headers: auth_headers

    assert_response 200
    assert_equal ok_response, json_response
  end

  test "should accept valid magic token only once" do
    @user.generate_magic_login_token
    token = @user.signed_magic_login_token

    assert_difference ['Session.count', 'UserAction.count'] do
      post api_v1_magic_link_sessions_url, params: { token: token }, headers: auth_headers
    end

    assert_response 201
    assert_session_response(@user.reload)

    assert_no_difference ['Session.count', 'UserAction.count'] do
      post api_v1_magic_link_sessions_url, params: { token: token }, headers: auth_headers
    end

    assert_invalid_token_error
  end

  test "should reject expired magic token" do
    @user.generate_magic_login_token
    token = @user.signed_magic_login_token

    travel 65.minutes

    assert_no_difference ['Session.count', 'UserAction.count'] do
      post api_v1_magic_link_sessions_url, params: { token: token }, headers: auth_headers
    end

    assert_invalid_token_error
  end

  def assert_invalid_token_error
    assert_response 401
    assert_equal error_response("credentials" => ["sessions.invalid_magic_login_token"]), json_response
  end
end
