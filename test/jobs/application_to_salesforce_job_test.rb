require 'test_helper'
include ActiveJob::TestHelper
class ApplicationToSalesforceJobTest < ActiveSupport::TestCase

  def setup
    stub_request(:post, "https://test.salesforce.com/services/oauth2/token").to_return(status: 200, body:
        '{"instance_url":"https://example.salesforce.com/"}')
  WebMock.disable_net_connect!(allow_localhost: true)
  end

  test 'failure response throws exception' do
    stub_request(:post, "https://example.salesforce.com/services/apexrest/PortalData").
        to_return(status: 200, body: '{"statusCode":"401","status":"Failed","projectRefNumber":null,"ProjectCostRefID":null,"Costs":null,"Costheading":null,"caseNumber":null,"caseId":null,"accountId":null}')
    project = projects(:one)
    assert_raises ApplicationToSalesforceJob::SalesforceApexError do
      ApplicationToSalesforceJob.perform_now(project)
    end
  end
end
