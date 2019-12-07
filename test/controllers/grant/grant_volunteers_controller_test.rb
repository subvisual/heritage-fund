require 'test_helper'

class Grant::GrantVolunteersControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_volunteers" do
    get grant_grant_volunteers_grant_volunteers_url
    assert_response :success
  end

end
