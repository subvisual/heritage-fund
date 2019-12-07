require 'test_helper'

class Organisation::OrganisationAboutControllerTest < ActionDispatch::IntegrationTest
  test "should get organisation_about" do
    get organisation_organisation_about_organisation_about_url
    assert_response :success
  end

end
