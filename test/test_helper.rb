ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

module TestPasswordHelper
  def default_password_digest
    BCrypt::Password.create(default_password, cost: 4)
  end

  def default_password
    "password"
  end
end

ActiveRecord::FixtureSet.context_class.send :include, TestPasswordHelper

class ActiveSupport::TestCase
  include TestPasswordHelper

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def auth_headers
    { "X-Api-Key" => client_apps(:default).api_key }
  end

  def json_response
    ActiveSupport::JSON.decode(@response.body)
  end

  def error_response(errors)
    { "errors" => errors }
  end

  def sign_in_as(user)
    user.generate_magic_login_token
    post api_v1_magic_link_sessions_url, params: { token: user.signed_magic_login_token }, as: :json, headers: auth_headers
  end

  def ok_response
    { "result" => "ok" }
  end

  def assert_session_response(user)
    resp = json_response

    assert resp["token"].present?
    assert resp["user"].present?

    assert resp["token"]["access_token"].present?
    assert resp["token"]["expires_in"].present?

    assert_equal user.email, resp["user"]["email"]
    assert_equal user.identifier, resp["user"]["identifier"]
    assert_equal user.email_confirmed, resp["user"]["email_confirmed"]

    assert_equal Session.last.refresh_token, refresh_token(user)
  end

  def refresh_token(user)
    cookies_hash = cookies.to_hash
    return nil if cookies_hash.empty?

    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies_hash)
    jar.encrypted[:"#{user.client_app.identifier}_auth"]
  end
end
