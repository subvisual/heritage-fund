require 'test_helper'

class Project::ProjectInvolvementControllerTest < ActionDispatch::IntegrationTest
  test "should get project_involvement" do
    get project_project_involvement_project_involvement_url
    assert_response :success
  end

end
