require 'test_helper'

class Organisation::OrganasationMissionControllerTest < ActionDispatch::IntegrationTest
  test "should get organisation_mission" do
    get organisation_organasation_mission_organisation_mission_url
    assert_response :success
  end

end
