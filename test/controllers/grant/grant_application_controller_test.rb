require 'test_helper'

class Grant::GrantApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_application" do
    get grant_grant_application_grant_application_url
    assert_response :success
  end

end
