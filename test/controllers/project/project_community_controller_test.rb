require 'test_helper'

class Project::ProjectCommunityControllerTest < ActionDispatch::IntegrationTest
  test "should get project_community" do
    get project_project_community_project_community_url
    assert_response :success
  end

end
