require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    users(:one).confirm
    sign_in users(:one)
    post user_session_url
  end

end
