class HealthControllerTest < ActionDispatch::IntegrationTest
    test "should successfully call get_status" do
      get '/health'
      assert_response :success
      assert_equal JSON.parse(response.body)["status"], "OK"
    end
  
  end