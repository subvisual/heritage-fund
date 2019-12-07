require 'test_helper'

class Grant::GrantDeclarationControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_declaration" do
    get grant_grant_declaration_grant_declaration_url
    assert_response :success
  end

end
