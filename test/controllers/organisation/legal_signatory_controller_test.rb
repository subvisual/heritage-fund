require 'test_helper'

class Organisation::LegalSignatoryControllerTest < ActionDispatch::IntegrationTest
  test "should get legal_signatory" do
    get organisation_legal_signatory_legal_signatory_url
    assert_response :success
  end

end
