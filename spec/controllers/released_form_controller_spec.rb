require "rails_helper"

RSpec.describe ReleasedFormController do
  ActiveJob::Base.queue_adapter = :test

  before(:each) do
    username = Rails.configuration.x.consumer.username
    password = Rails.configuration.x.consumer.password
    request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end

  describe "POST #receive" do
    it "should enqueue a job" do
      project = create(
        :project,
        id: "2c660111-ab15-4221-98e0-cf0e02748a9b"
      )

      expect {
        post :receive,
          params: {
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
      }.to have_enqueued_job(ReleaseFormJob)
    end
  end
end
