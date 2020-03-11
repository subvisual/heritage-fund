require "rails_helper"

describe Project::EvidenceOfSupportController do
  login_user
  let(:project) { create(:project, id: "id", user_id: subject.current_user.id) }

  describe "GET #show" do

    it "should render the page successfully for a valid project" do
      get :show,
          params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:project).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show, params: { project_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "PUT #update" do

    it "should raise a ParameterMissing error if no project param is passed" do

      expect {
        put :update,
            params: { project_id: project.id }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should raise a ParameterMissing error if an empty project param " \
       "is passed" do

      expect {
        put :update,
            params: {
                project_id: project.id,
                project: { }
            }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if an empty description attribute is " \
       "passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  evidence_of_support_attributes: {
                      "0": {
                          description: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).evidence_of_support.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).evidence_of_support.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.evidence_of_support.attributes.description.blank"))
      expect(assigns(:project).evidence_of_support.first.errors.messages[:evidence_of_support_files][0])
          .to eq("Add an evidence of support file")

    end

    it "should re-render the page if a description attribute over 50 words" \
       " is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  evidence_of_support_attributes: {
                      "0": {
                          description: "word " * 51
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).evidence_of_support.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).evidence_of_support.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.evidence_of_support.attributes.description.too_long"))
      expect(assigns(:project).evidence_of_support.first.errors.messages[:evidence_of_support_files][0])
          .to eq("Add an evidence of support file")

    end

    it "should successfully update and redirect to the same page if valid " \
       "params are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  evidence_of_support_attributes: {
                      "0": {
                          description: "Test",
                          evidence_of_support_files:
                              Rack::Test::UploadedFile.new(
                                  Rails.root + "spec/fixtures/files/example.txt"
                              )
                      }
                  }
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_support_evidence)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).evidence_of_support.first.errors.empty?)
          .to eq(true)
      expect(assigns(:project).evidence_of_support.first.description)
          .to eq("Test")
      expect(assigns(:project)
                 .evidence_of_support.first.evidence_of_support_files.attached?)
          .to eq(true)

    end

  end

  describe "DELETE #delete" do

    it "should redirect to root for an invalid project" do

      delete :delete,
             params: {
                 project_id: "invalid",
                 supporting_evidence_id: "invalid"
             }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

    it "should fail to find an invalid supporting_evidence_id and redirect " \
       "back" do

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   supporting_evidence_id: "invalid"
               }
      }.to raise_error(ActiveRecord::RecordNotFound)

    end

    it "should delete a valid supporting_evidence_id and redirect back" do

      evidence_of_support = create(
          :evidence_of_support,
          project_id: project.id,
          description: "Test",
          evidence_of_support_files: Rack::Test::UploadedFile.new(
              Rails.root + "spec/fixtures/files/example.txt"
          )
      )

      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).ordered
      expect(Rails.logger)
          .to receive(:info).at_least(:once)
                  .with("Deleting supporting evidence ID: " \
                        "#{evidence_of_support.id}")

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   supporting_evidence_id: evidence_of_support.id
               }
      }.to change(project.evidence_of_support, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_support_evidence)

    end

  end

end

