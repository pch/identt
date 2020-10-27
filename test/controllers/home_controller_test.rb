require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url, headers: auth_headers
    assert_response :success
  end
end
