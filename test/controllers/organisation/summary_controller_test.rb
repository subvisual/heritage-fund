require 'test_helper'

class Organisation::SummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get summary" do
    get organisation_summary_summary_url
    assert_response :success
  end

end
