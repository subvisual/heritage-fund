require 'test_helper'

class Project::ProjectCashContributionControllerTest < ActionDispatch::IntegrationTest
  test "should get project_cash_contribution" do
    get project_project_cash_contribution_project_cash_contribution_url
    assert_response :success
  end

  test "should get project_cash_contribution_yes" do
    get project_project_cash_contribution_project_cash_contribution_yes_url
    assert_response :success
  end

end
