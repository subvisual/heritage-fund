require 'test_helper'

class Project::AboutControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get project_about_about_url
    assert_response :success
  end

end
