require 'test_helper'

class Organisation::RegisteredNumbersControllerTest < ActionDispatch::IntegrationTest
  test "should get registered_numbers" do
    get organisation_registered_numbers_registered_numbers_url
    assert_response :success
  end

end
