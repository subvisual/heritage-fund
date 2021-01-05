require "rails_helper"

RSpec.describe ReleaseFormJob, type: :job do
  context "setup project" do
    let(:project) {
      create(
        :project,
        id: "2c660111-ab15-4221-98e0-cf0e02748a9b"
      )
    }

    it "releases Permission To Start form" do
      params = {
        GrantDecision: "Awarded",
        ProjectCosts: ["PC-000095"],
        forms: [],
        Email: "lizzie90@example.com",
        ContactName: "Nelda",
        ApprovedPurpose: {},
        ApplicationStages: " Finance Approval",
        ApplicationId: project.id,
        AccountName: "New web test org",
        AccountExternalID: "5188ff34-9011-4458-a9ea-19fe1ac9f3c6",
        released_form: {}
      }

      ReleaseFormJob.perform_now(params, params.to_json)
      released_form = project.released_forms.first
      expect(released_form.form_type)
        .to eq("permission_to_start")
      expect(released_form.payload).to eq(params.to_json)
    end

    it "releases Completion Report form" do
      params = {
        Status: "Awarded",
        ProjectCosts: ["PC-000095"],
        forms: [],
        Email: "lizzie90@example.com",
        ContactName: "Nelda",
        ApprovedPurpose: {},
        ApplicationStages: "Finance Approval",
        ApplicationId: project.id,
        AccountName: "New web test org",
        AccountExternalID: "5188ff34-9011-4458-a9ea-19fe1ac9f3c6",
        released_form: {},
        ApprovedbyFinance: true
      }
      ReleaseFormJob.perform_now(params, params.to_json)
      released_form = project.released_forms.first
      expect(released_form.form_type)
        .to eq("completion_report")
      expect(released_form.payload).to eq(params.to_json)
    end
  end
end
