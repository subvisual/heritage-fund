require 'test_helper'

class Project::ProjectPermissionControllerTest < ActionDispatch::IntegrationTest
  test "should get project_permission" do
    get project_project_permission_project_permission_url
    assert_response :success
  end

end
