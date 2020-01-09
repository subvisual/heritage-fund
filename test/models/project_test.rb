require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
   test "serialises Salesforce JSON" do
     @project_salesforce_json_obj = JSON.parse(projects(:one).to_salesforce_json)

     # Assert meta parameters
     assert_equal  '2c660111-ab15-4221-98e0-cf0e02748a9b', @project_salesforce_json_obj['meta']['applicationId']
     assert_equal 'test@example.com', @project_salesforce_json_obj['meta']['username']

     # Assert organisation parameters
     assert_equal 'test organisation', @project_salesforce_json_obj['application']['organisationName']
     assert_equal 'registered-charity', @project_salesforce_json_obj['application']['organisationType']
     assert_equal 'line 1', @project_salesforce_json_obj['application']['organisationAddress']['line1']
     assert_equal 'town', @project_salesforce_json_obj['application']['organisationAddress']['townCity']
     assert_equal 'John Doe', @project_salesforce_json_obj['application']['authorisedSignatoryOneDetails']['name']
     assert_equal 'Jane Doe', @project_salesforce_json_obj['application']['authorisedSignatoryTwoDetails']['name']
     assert_equal '12345', @project_salesforce_json_obj['application']['charityNumber']
     assert_equal '54321', @project_salesforce_json_obj['application']['companyNumber']
     assert_equal %w(black-or-minority-ethnic-led disability-led lgbt+-led female-led young-people-led),
                  @project_salesforce_json_obj['application']['organisationMission']

     # Assert project parameters
     assert_equal 'Test Project', @project_salesforce_json_obj['application']['projectName']
     assert_equal '2025-01-01', @project_salesforce_json_obj['application']['projectDateRange']['startDate']
     assert_equal '2025-10-01', @project_salesforce_json_obj['application']['projectDateRange']['endDate']
     assert_equal '10 Downing Street', @project_salesforce_json_obj['application']['projectAddress']['line1']
     assert_equal 'Westminster', @project_salesforce_json_obj['application']['projectAddress']['line2']
     assert_equal 'London', @project_salesforce_json_obj['application']['projectAddress']['townCity']
     assert_equal 'Greater London', @project_salesforce_json_obj['application']['projectAddress']['county']
     assert_equal 'SW1A 2AA', @project_salesforce_json_obj['application']['projectAddress']['projectPostcode']
     assert_equal 'A description of my project...', @project_salesforce_json_obj['application']['yourIdeaProject']
     assert_equal 'The difference my project will make to...',
                  @project_salesforce_json_obj['application']['projectDifference']
     assert_equal 'My project matters because...', @project_salesforce_json_obj['application']['projectCommunity']
     assert_equal 'My organisation is best placed to...',
                  @project_salesforce_json_obj['application']['projectOrgBestPlace']
     assert_equal 'The heritage of my project...', @project_salesforce_json_obj['application']['projectAvailable']
     assert_equal 'My project will involve a wider range of people...',
                  @project_salesforce_json_obj['application']['projectOutcome1']
   end
end
