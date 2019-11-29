require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    sign_in users(:one)
    post user_session_url
  end

  test "should get show" do
    get dashboard_show_url
    assert_response :success
  end

end
