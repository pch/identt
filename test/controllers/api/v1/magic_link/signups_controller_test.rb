require 'test_helper'

class Api::V1::MagicLink::SignupsControllerTest < ActionDispatch::IntegrationTest
  test "should throw 401 on missing api key" do
    post api_v1_magic_link_signups_url, params: { user: { email: "foo" } }

    assert_response 401
    assert_equal error_response("api_key" => ["auth.invalid_or_missing_api_key"]), json_response
  end

  test "should sign up user and send a magic link" do
    SendMagicLink.expects(:call)

    assert_difference 'User.count' do
      post api_v1_magic_link_signups_url, params: { user: { email: "foo@example.com" } }, headers: auth_headers
    end

    assert_response 200
    assert_equal ok_response, json_response
  end

  test "should only send a magic link if existing user tries to sign up" do
    user = users(:john)

    SendMagicLink.expects(:call)

    assert_no_difference 'User.count' do
      post api_v1_magic_link_signups_url, params: { user: { email: user.email } }, headers: auth_headers
    end

    assert_response 200
    assert_equal ok_response, json_response
  end

  test "should return error on invalid email" do
    assert_no_difference 'User.count' do
      post api_v1_magic_link_signups_url, params: { user: { email: "foo" } }, headers: auth_headers
    end

    assert_response 422
    assert_equal error_response("email" => ["signup.email_invalid_format"]), json_response
  end
end
