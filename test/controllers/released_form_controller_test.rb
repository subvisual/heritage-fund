require 'test_helper'
require_relative '../support/fake_salesforce_webhook'

class ReleasedFormControllerTest < ActionDispatch::IntegrationTest

  test "stub project exists" do
    assert_equal 1, Project.count
  end                                

  test "webhook releases permission to start" do
    application_id = '2c660111-ab15-4221-98e0-cf0e02748a9b'
    post '/consumer', params: {"GrantDecision"=>"Awarded", "ProjectCosts"=>["PC-000095"], "forms"=>[], "Email"=>"lizzie90@example.com", "ContactName"=>"Nelda", "ApprovedPurpose"=>{}, "ApplicationStages"=>"Finance Approval", "ApplicationId"=>application_id, "AccountName"=>"New web test org", "AccountExternalID"=>"5188ff34-9011-4458-a9ea-19fe1ac9f3c6", "released_form"=>{}}
    assert Project.find(application_id).released_forms.first.form_type = :permission_to_start
  end

  test "webhook with finance does not release permission to start" do
    application_id = '2c660111-ab15-4221-98e0-cf0e02748a9b'
    post '/consumer', params: {"Status"=>"Awarded", "ProjectCosts"=>["PC-000095"], "forms"=>[], "Email"=>"lizzie90@example.com", "ContactName"=>"Nelda", "ApprovedPurpose"=>{}, "ApplicationStages"=>"Finance Approval", "ApplicationId"=>application_id, "AccountName"=>"New web test org", "AccountExternalID"=>"5188ff34-9011-4458-a9ea-19fe1ac9f3c6", "released_form"=>{}, "ApprovedbyFinance"=>true}
    assert Project.find(application_id).released_forms.first.form_type = :completion_report
  end


end
