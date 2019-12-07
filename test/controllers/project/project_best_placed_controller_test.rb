require 'test_helper'

class Project::ProjectBestPlacedControllerTest < ActionDispatch::IntegrationTest
  test "should get project_best_placed" do
    get project_project_best_placed_project_best_placed_url
    assert_response :success
  end

end
