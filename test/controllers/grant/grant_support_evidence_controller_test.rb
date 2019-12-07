require 'test_helper'

class Grant::GrantSupportEvidenceControllerTest < ActionDispatch::IntegrationTest
  test "should get grant_support_evidence" do
    get grant_grant_support_evidence_grant_support_evidence_url
    assert_response :success
  end

end
