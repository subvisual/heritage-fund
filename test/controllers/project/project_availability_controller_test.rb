require 'test_helper'

class Project::ProjectAvailabilityControllerTest < ActionDispatch::IntegrationTest
  test "should get project_availability" do
    get project_project_availability_project_availability_url
    assert_response :success
  end

end
