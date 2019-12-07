require 'test_helper'

class Project::ProjectOtherOutcomesControllerTest < ActionDispatch::IntegrationTest
  test "should get project_other_outcomes" do
    get project_project_other_outcomes_project_other_outcomes_url
    assert_response :success
  end

end
