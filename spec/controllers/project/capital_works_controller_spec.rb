require "rails_helper"

describe Project::CapitalWorksController do
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

    it "should redirect to the next page if no params are passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update,
          params: { project_id: project.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:capital_work][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.capital_work.inclusion"))

    end

    it "should re-render the page if an empty capital_work param is passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              capital_work: ""
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:capital_work][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.capital_work.inclusion"))

    end

    it "should re-render the page if an invalid capital_work param is passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              capital_work: "invalid"
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:capital_work][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.capital_work.inclusion"))

    end

    it "should successfully update and redirect to the next page if a valid " \
       "capital_work param is passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              capital_work: "true"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_permission_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).capital_work).to eq(true)

    end

    it "should successfully update and redirect to the same page if valid " \
       "capital_work and capital_work_file params are passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              capital_work: "true",
              capital_work_file: Rack::Test::UploadedFile.new(Rails.root + "spec/fixtures/files/example.txt")
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_capital_works_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).capital_work).to eq(true)

    end

  end

end

