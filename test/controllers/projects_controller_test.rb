require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest


  setup do
    get '/users/sign_in'
    users(:one).confirm
    sign_in users(:one)
    post user_session_url
    @project = projects(:one)
  end

  test "should get new" do
       get new_project_url
       assert_response :success
  end
   

    test "should show project" do
      get project_url(@project)
      assert_response :success
    end
  
    test "should get edit" do
      get edit_project_url(@project)
      assert_response :success
    end
end
