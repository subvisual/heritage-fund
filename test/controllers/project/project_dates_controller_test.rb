require 'test_helper'

class Project::ProjectDatesControllerTest < ActionDispatch::IntegrationTest
  test "should get project_dates" do
    get project_project_dates_project_dates_url
    assert_response :success
  end

end
