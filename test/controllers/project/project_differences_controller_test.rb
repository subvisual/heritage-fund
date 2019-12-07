require 'test_helper'

class Project::ProjectDifferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get project_differences" do
    get project_project_differences_project_differences_url
    assert_response :success
  end

end
