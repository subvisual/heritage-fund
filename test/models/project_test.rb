require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
   test "serialises Salesforce JSON" do
     @project_salesforce_json_obj = JSON.parse(projects(:one).to_salesforce_json)

     # Assert meta parameters
     assert_equal  '2c660111-ab15-4221-98e0-cf0e02748a9b', @project_salesforce_json_obj['meta']['applicationId']
     assert_equal 'test@example.com', @project_salesforce_json_obj['meta']['username']

     # Assert mainContact parameters
     assert_equal "Joe O'Bloggs", @project_salesforce_json_obj['application']['mainContactName']
     assert_equal "07700900000", @project_salesforce_json_obj['application']['mainContactPhone']
     assert_equal "test@example.com", @project_salesforce_json_obj['application']['mainContactEmail']
     assert_equal "10 Downing Street", @project_salesforce_json_obj['application']['mainContactAddress']['line1']
     assert_equal "Westminster", @project_salesforce_json_obj['application']['mainContactAddress']['line2']
     assert_equal "London", @project_salesforce_json_obj['application']['mainContactAddress']['townCity']
     assert_equal "Greater London", @project_salesforce_json_obj['application']['mainContactAddress']['county']
     assert_equal "SW1A 2AA", @project_salesforce_json_obj['application']['mainContactAddress']['postcode']

     # Assert organisation parameters
     assert_equal 'test organisation', @project_salesforce_json_obj['application']['organisationName']
     assert_equal 'registered-charity', @project_salesforce_json_obj['application']['organisationType']
     assert_equal 'line 1', @project_salesforce_json_obj['application']['organisationAddress']['line1']
     assert_equal 'town', @project_salesforce_json_obj['application']['organisationAddress']['townCity']
     assert_equal 'Jane Doe', @project_salesforce_json_obj['application']['authorisedSignatoryOneDetails']['name']
     assert_equal 'John Doe', @project_salesforce_json_obj['application']['authorisedSignatoryTwoDetails']['name']
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
     assert_equal 'Description of outcome 2', @project_salesforce_json_obj['application']['projectOutcome2']
     assert_equal '', @project_salesforce_json_obj['application']['projectOutcome3']
     assert_equal 'Description of outcome 4', @project_salesforce_json_obj['application']['projectOutcome4']
     assert_equal '', @project_salesforce_json_obj['application']['projectOutcome5']
     assert_equal 'Description of outcome 6', @project_salesforce_json_obj['application']['projectOutcome6']
     assert_equal '', @project_salesforce_json_obj['application']['projectOutcome7']
     assert_equal 'Description of outcome 8', @project_salesforce_json_obj['application']['projectOutcome8']
     assert_equal '', @project_salesforce_json_obj['application']['projectOutcome9']
     assert_equal true, @project_salesforce_json_obj['application']['projectOutcome2Checked']
     assert_equal false, @project_salesforce_json_obj['application']['projectOutcome3Checked']
     assert_equal true, @project_salesforce_json_obj['application']['projectOutcome4Checked']
     assert_equal false, @project_salesforce_json_obj['application']['projectOutcome5Checked']
     assert_equal true, @project_salesforce_json_obj['application']['projectOutcome6Checked']
     assert_equal false, @project_salesforce_json_obj['application']['projectOutcome7Checked']
     assert_equal true, @project_salesforce_json_obj['application']['projectOutcome8Checked']
     assert_equal false, @project_salesforce_json_obj['application']['projectOutcome9Checked']
     assert_equal 'not-sure', @project_salesforce_json_obj['application']['projectNeedsPermission']
     assert_equal 'permission description', @project_salesforce_json_obj['application']['projectNeedsPermissionDetails']
     assert_equal 'partnership details', @project_salesforce_json_obj['application']['partnershipDetails']
   end
end
