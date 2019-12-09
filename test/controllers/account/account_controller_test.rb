require 'test_helper'

class Account::AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get account_account_new_url
    assert_response :success
  end

end
