require "rails_helper"

describe Project::CashContributionsController do
  login_user
  let(:project) { create(:project, id: "id", user_id: subject.current_user.id) }

  describe "GET #question" do

    it "should render the page successfully for a valid project" do
      get :question,
          params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)
      expect(assigns(:project).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :question, params: { project_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

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

  describe "PUT #update_question" do

    it "should re-render the page if no project param is passed" do

      put :question_update,
          params: { project_id: project.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.cash_contributions_question.inclusion"))

    end

    it "should re-render the page if an empty project param is passed" do

      put :question_update,
          params: {
              project_id: project.id,
              project: { }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.cash_contributions_question.inclusion"))

    end

    it "should re-render the page if an invalid " \
       "cash_contributions_question param is passed" do

      put :question_update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_question: "invalid"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.cash_contributions_question.inclusion"))

    end

    it "should successfully redirect if a valid " \
       "cash_contributions_question param of 'false' is passed" do

      put :question_update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_question: "false"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_grant_request_get)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

    it "should successfully redirect if a valid " \
       "cash_contributions_question param of 'true' is passed" do

      put :question_update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_question: "true"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_cash_contribution)

      expect(assigns(:project).errors.empty?).to eq(true)

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

    it "should re-render the page if empty attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "",
                          secured: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.description.blank"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:secured][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.secured.inclusion"))

    end

    it "should re-render the page if description param which exceeds max " \
       "length is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "word " * 51,
                          amount: "",
                          secured: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.description.too_long"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:secured][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.secured.inclusion"))

    end

    it "should re-render the page if amount param which is not an integer is " \
       "passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "string",
                          secured: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.description.blank"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:secured][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.secured.inclusion"))

    end

    it "should re-render the page if amount param which contains a negative " \
       "number is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "-50",
                          secured: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.amount.greater_than"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.description.blank"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:secured][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.secured.inclusion"))

    end

    it "should re-render the page if secured param of 'yes_with_evidence' is " \
       "passed without a file" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "",
                          secured: "yes_with_evidence"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:project).cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.description.blank"))
      expect(assigns(:project).cash_contributions.first.errors.messages[:cash_contribution_evidence_files][0])
          .to eq(I18n.t("activerecord.errors.models.cash_contribution.attributes.cash_contribution_evidence_files.inclusion"))

    end

    it "should successfully update if valid params (without file) are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "Test",
                          amount: "1000",
                          secured: "yes_no_evidence_yet"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_cash_contribution)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(true)
      expect(assigns(:project).cash_contributions.first.description)
          .to eq("Test")
      expect(assigns(:project).cash_contributions.first.amount)
          .to eq(1000)
      expect(assigns(:project).cash_contributions.first.secured)
          .to eq("yes_no_evidence_yet")

    end

    it "should successfully update if valid params (with file) are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  cash_contributions_attributes: {
                      "0": {
                          description: "Test",
                          amount: "1000",
                          secured: "yes_with_evidence",
                          cash_contribution_evidence_files:
                              Rack::Test::UploadedFile.new(
                                  Rails.root + "spec/fixtures/files/example.txt"
                              )
                      }
                  }
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_cash_contribution)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).cash_contributions.first.errors.empty?)
          .to eq(true)
      expect(assigns(:project).cash_contributions.first.description)
          .to eq("Test")
      expect(assigns(:project).cash_contributions.first.amount)
          .to eq(1000)
      expect(assigns(:project).cash_contributions.first.secured)
          .to eq("yes_with_evidence")
      expect(assigns(:project).
          cash_contributions.first.cash_contribution_evidence_files.attached?)
          .to eq(true)

    end

  end

  describe "DELETE #delete" do

    it "should redirect to root for an invalid project" do

      delete :delete,
             params: {
                 project_id: "invalid",
                 cash_contribution_id: "invalid"
             }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

    it "should fail to find an invalid cash contribution and redirect back" do

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   cash_contribution_id: "invalid"
               }
      }.to raise_error(ActiveRecord::RecordNotFound)

    end

    it "should delete a valid cash contribution and redirect back" do

      cash_contribution = create(
          :cash_contribution,
          project_id: project.id,
          description: "Test",
          secured: "no",
          amount: 5
      )

      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).ordered
      expect(Rails.logger)
          .to receive(:info).at_least(:once)
                  .with("Deleting cash contribution ID: " \
                        "#{cash_contribution.id}")

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   cash_contribution_id: cash_contribution.id
               }
      }.to change(project.cash_contributions, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_project_cash_contribution)

    end

  end

end
