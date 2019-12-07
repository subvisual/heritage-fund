require 'test_helper'

class Project::ProjectLocationControllerTest < ActionDispatch::IntegrationTest
  test "should get project_location" do
    get project_project_location_project_location_url
    assert_response :success
  end

  test "should get project_location_no" do
    get project_project_location_project_location_no_url
    assert_response :success
  end

end
