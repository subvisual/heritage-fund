require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
   test "serialises Salesforce JSON" do
     @project = projects(:one)
     @project_salesforce_json_obj = JSON.parse(@project.to_salesforce_json)
     assert_equal  '2c660111-ab15-4221-98e0-cf0e02748a9b', @project_salesforce_json_obj['meta']['applicationId']
     assert_equal 'test@example.com', @project_salesforce_json_obj['meta']['username']
     assert_equal 'test organisation', @project_salesforce_json_obj['application']['organisationName']
     assert_equal 'registered-charity', @project_salesforce_json_obj['application']['organisationType']
     assert_equal 'line 1', @project_salesforce_json_obj['application']['organisationAddress']['line1']
     assert_equal 'town', @project_salesforce_json_obj['application']['organisationAddress']['townCity']
     assert_equal 'John Doe', @project_salesforce_json_obj['application']['authorisedSignatoryOneDetails']['name']
     assert_equal 'Jane Doe', @project_salesforce_json_obj['application']['authorisedSignatoryTwoDetails']['name']
     assert_equal '123', @project_salesforce_json_obj['application']['charityNumber']
     assert_equal %w(black-or-minority-ethnic-led disability-led lgbt+-led female-led young-people-led), @project_salesforce_json_obj['application']['organisationMission']
   end
end
