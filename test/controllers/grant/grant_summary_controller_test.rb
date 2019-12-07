require 'test_helper'

class Grant::GrantSummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_summary" do
    get grant_grant_summary_grant_summary_url
    assert_response :success
  end

end
