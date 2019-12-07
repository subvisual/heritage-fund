require 'test_helper'

class Project::NewProjectControllerTest < ActionDispatch::IntegrationTest
  test "should get new_project" do
    get project_new_project_new_project_url
    assert_response :success
  end

end
