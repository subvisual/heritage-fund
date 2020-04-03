require "rails_helper"

RSpec.describe Project::PermissionController do
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

    it "should raise a ParameterMissing error if no params are passed" do

      expect{
        put :update, params: {
            project_id: project.id
        }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project")

    end

    it "should raise a ParameterMissing error if an empty project param " \
       "is passed" do

      expect {
        put :update, params: {
            project_id: project.id,
            project: {}
        }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if an empty permission_type param is " \
       "passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: ""
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:permission_type][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.permission_type.blank"))

    end

    it "should re-render the page if a permission_type param of 'yes' is " \
       "passed with no permission_description param" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: "yes"
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:permission_description_yes][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.permission_description_yes.blank"))

    end

    it "should re-render the page if a permission_type param of 'yes' is " \
       "passed with no permission_description param" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: "x_not_sure"
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:permission_description_x_not_sure][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.permission_description_x_not_sure.blank"))

    end

    it "should successfully update if a permission_type param of 'no' " \
       "is passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: "no"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_difference_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).permission_type).to eq("no")

    end

    it "should successfully update if a permission_type param of 'yes' " \
       "is passed with a permission_description_yes param" do

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: "yes",
              permission_description_yes: "Test"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_difference_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).permission_type).to eq("yes")
      expect(assigns(:project).permission_description).to eq("Test")

    end

    it "should successfully update if a permission_type param of 'x_not_sure'" \
       " is passed with a permission_description_x_not_sure param" do

      put :update, params: {
          project_id: project.id,
          project: {
              permission_type: "x_not_sure",
              permission_description_x_not_sure: "Test"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_difference_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).permission_type).to eq("x_not_sure")
      expect(assigns(:project).permission_description).to eq("Test")

    end

  end

end
