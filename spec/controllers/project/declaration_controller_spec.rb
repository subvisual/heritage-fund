require "rails_helper"

RSpec.describe Project::DeclarationController do
  login_user
  let(:project) { create(:project, id: "id", user_id: subject.current_user.id, is_partnership: false) }

  describe "GET #show_declaration" do

    it "should render the page successfully for a valid project" do
      get :show_declaration,
          params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_declaration)
      expect(assigns(:project).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show_declaration, params: { project_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "GET #show_confirm_declaration" do

    it "should render the page successfully for a valid project" do
      get :show_confirm_declaration,
          params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_confirm_declaration)
      expect(assigns(:project).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show_confirm_declaration, params: { project_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "PUT #update_confirm_declaration" do

    it "should re-render the page if no params are passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update_confirm_declaration,
          params: { project_id: project.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_confirm_declaration)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:confirm_declaration][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.confirm_declaration.inclusion"))

    end

    it "should re-render the page if an empty project param is passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update_confirm_declaration,
          params: {
              project_id: project.id,
              project: { }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_confirm_declaration)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:confirm_declaration][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.confirm_declaration.inclusion"))

    end

    it "should re-render the page if an invalid confirm_declaration param is " \
       "passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update_confirm_declaration,
          params: {
              project_id: project.id,
              project: {
                  confirm_declaration: "invalid"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_confirm_declaration)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:confirm_declaration][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.confirm_declaration.inclusion"))

    end

    # TODO remove bau flipper
    it "should successfully update if a valid confirm_declaration param is " \
       "passed" do

      begin

        Flipper[:bau].enable

        expect(ApplicationToSalesforceJob).to \
         receive(:perform_later).with(project)

        put :update_confirm_declaration,
            params: {
                project_id: project.id,
                project: {
                    user_research_declaration: "true",
                    confirm_declaration: "true"
                }
            }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(
                                :three_to_ten_k_project_application_submitted
                            )

        expect(assigns(:project).errors.empty?).to eq(true)
        expect(assigns(:project).confirm_declaration).to eq("true")
        expect(assigns(:project).user_research_declaration).to eq(true)

      ensure
        Flipper[:bau].disable
      end

    end

  # TODO remove bau flipper
  it "should successfully update based on Flipper[:bau] if a valid " \
     "confirm_declaration param is passed" do

      expect(ApplicationToSalesforceJob).not_to \
         receive(:perform_later).with(project)

      put :update_confirm_declaration,
          params: {
              project_id: project.id,
              project: {
                  user_research_declaration: "true",
                  confirm_declaration: "true"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              :three_to_ten_k_project_confirm_declaration
                          )

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).confirm_declaration).to eq("true")
      expect(assigns(:project).user_research_declaration).to eq(true)

  end

end

  describe "PUT #update_declaration" do

    it "should re-render the page if no params are passed" do

      expect {
        put :update_declaration,
            params: { project_id: project.id }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if no params are passed" do

      expect {
        put :update_declaration,
            params: {
                project_id: project.id,
                project: { }
            }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should successfully update if an invalid is_partnership param is " \
       "passed" do

      # As this is a Boolean field, Rails will interpret any String value
      # which is not falsey as a truthy value, and therefore update the
      # field to True.
      # See https://stackoverflow.com/a/5171074/5890174

      put :update_declaration,
          params: {
              project_id: project.id,
              project: {
                  is_partnership: "invalid"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              :three_to_ten_k_project_confirm_declaration
                          )

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).is_partnership).to eq(true)

    end

    it "should successfully update if a valid is_partnership param is " \
       "passed" do

      put :update_declaration,
          params: {
              project_id: project.id,
              project: {
                  declaration_reasons_description: "Test",
                  keep_informed_declaration: "false",
                  is_partnership: "false"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              :three_to_ten_k_project_confirm_declaration
                          )

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).declaration_reasons_description).to eq("Test")
      expect(assigns(:project).keep_informed_declaration).to eq(false)
      expect(assigns(:project).is_partnership).to eq(false)

    end

    it "should re-render the page is an is_partnership param of 'true' is " \
       "passed with no partnership_details param" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update_declaration,
          params: {
              project_id: project.id,
              project: {
                  declaration_reasons_description: "Test",
                  keep_informed_declaration: "false",
                  is_partnership: "true"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show_declaration)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:partnership_details][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.partnership_details.blank"))

    end

    it "should successfully update if all params are passed" do

      put :update_declaration,
          params: {
              project_id: project.id,
              project: {
                  declaration_reasons_description: "Test",
                  keep_informed_declaration: "true",
                  is_partnership: "true",
                  partnership_details: "Testing"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              :three_to_ten_k_project_confirm_declaration
                          )

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).declaration_reasons_description).to eq("Test")
      expect(assigns(:project).keep_informed_declaration).to eq(true)
      expect(assigns(:project).is_partnership).to eq(true)
      expect(assigns(:project).partnership_details).to eq("Testing")

    end

  end

end
