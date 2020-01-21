require 'test_helper'
class ApplicationToSalesforceJobTest < ActiveSupport::TestCase

  def setup
    stub_request(:post, "https://test.salesforce.com/services/oauth2/token").to_return(status: 200, body:
        '{"instance_url":"https://example.salesforce.com/"}')
  WebMock.disable_net_connect!
  end

  test 'failure response throws exception' do
    stub_request(:post, "https://example.salesforce.com/services/apexrest/PortalData").
        to_return(status: 200, body: '{"statusCode":"401","status":"Failed","projectRefNumber":null,"ProjectCostRefID":null,"Costs":null,"Costheading":null,"caseNumber":null,"caseId":null,"accountId":null}')
    project = projects(:one)
    assert_raises ApplicationToSalesforceJob::SalesforceApexError do
      ApplicationToSalesforceJob.perform_now(project)
    end
  end

  test 'success case updates database' do
    stub_request(:post, "https://example.salesforce.com/services/apexrest/PortalData").
        to_return(status: 200, body: {"statusCode"=>"200", "status"=>"Success", "projectRefNumber"=>"NS-19-01498", "ProjectCostRefID"=>nil, "Costs"=>nil, "Costheading"=>nil, "caseNumber"=>"00001498", "caseId"=>"5002500000BFRUiAAP", "accountId"=>"0012500001I6ImfAAF"}.to_json)
    project = projects(:one)
    ApplicationToSalesforceJob.perform_now(project)
    assert_equal("NS-19-01498", project.project_reference_number)
    assert_equal("5002500000BFRUiAAP", project.salesforce_case_id)
    assert_equal("0012500001I6ImfAAF", project.organisation.salesforce_account_id)
    assert_equal("00001498", project.salesforce_case_number)

  end
end
