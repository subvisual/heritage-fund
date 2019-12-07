require 'test_helper'

class Project::ProjectDescriptionControllerTest < ActionDispatch::IntegrationTest
  test "should get project_description" do
    get project_project_description_project_description_url
    assert_response :success
  end

end
