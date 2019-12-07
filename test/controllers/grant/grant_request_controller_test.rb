require 'test_helper'

class Grant::GrantRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_request" do
    get grant_grant_request_grant_request_url
    assert_response :success
  end

end
