require "rails_helper"
require_relative '../support/fake_salesforce_webhook'

describe ReleasedFormController do

  describe "POST #receive" do

    it "should release the permission to start from the webhook" do

      project = create(
          :project,
          id: '2c660111-ab15-4221-98e0-cf0e02748a9b'
      )

      post :receive, params: {
          GrantDecision: "Awarded",
          ProjectCosts: ["PC-000095"],
          forms: [],
          Email: "lizzie90@example.com",
          ContactName: "Nelda",
          ApprovedPurpose: {},
          ApplicationStages:" Finance Approval",
          ApplicationId: project.id,
          AccountName: "New web test org",
          AccountExternalID: "5188ff34-9011-4458-a9ea-19fe1ac9f3c6",
          released_form: {}
      }

      expect(project.released_forms.first.form_type)
          .to eq("permission_to_start")

    end

    it "should not release the permission to start from a webhook with Finance" do

      project = create(
          :project,
          id: '2c660111-ab15-4221-98e0-cf0e02748a9c'
      )

      post :receive, params: {
          Status: "Awarded",
          ProjectCosts: ["PC-000095"],
          forms:[],
          Email: "lizzie90@example.com",
          ContactName: "Nelda",
          ApprovedPurpose: {},
          ApplicationStages: "Finance Approval",
          ApplicationId: project.id,
          AccountName: "New web test org",
          AccountExternalID: "5188ff34-9011-4458-a9ea-19fe1ac9f3c6",
          released_form: {},
          ApprovedbyFinance:true}

      expect(project.released_forms.first.form_type)
          .to eq("completion_report")

    end

  end

end
