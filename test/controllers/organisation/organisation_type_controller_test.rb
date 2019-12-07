require 'test_helper'

class Organisation::OrganisationTypeControllerTest < ActionDispatch::IntegrationTest
  test "should get organisation_type" do
    get organisation_organisation_type_organisation_type_url
    assert_response :success
  end

end
