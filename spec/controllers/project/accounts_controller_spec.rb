require "rails_helper"

RSpec.describe Project::AccountsController do
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

    it "should re-render the show template if no params are passed" do

      put :update, params: { project_id: project.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:accounts_files][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.accounts_files.inclusion"))

    end

    it "should re-render the show template if an empty project param is " \
       "passed" do

      put :update,
          params: {
              project_id: project.id,
              project: { }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:accounts_files][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.accounts_files.inclusion"))

    end

    it "should raise an InvalidSignature exception if an empty string is " \
       "passed in the accounts_file param" do

      expect {
        put :update,
            params: {
                project_id: project.id,
                project: {
                    accounts_files: [""]
                }
            }
      }.to raise_error(ActiveSupport::MessageVerifier::InvalidSignature)

    end

    it "should successfully update if a single file is uploaded" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  accounts_files: [
                      Rack::Test::UploadedFile.new(
                          "#{Rails.root}/spec/fixtures/files/example.txt"
                      )
                  ]
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_accounts_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(project.accounts_files.present?).to eq(true)
      expect(project.accounts_files.count).to eq(1)

    end

    it "should successfully update if multiple files are uploaded" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  accounts_files: [
                      Rack::Test::UploadedFile.new(
                          "#{Rails.root}/spec/fixtures/files/example.txt"
                      ),
                      Rack::Test::UploadedFile.new(
                          "#{Rails.root}/spec/fixtures/files/example.txt"
                      )
                  ]
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_accounts_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(project.accounts_files.present?).to eq(true)
      expect(project.accounts_files.count).to eq(2)

    end

  end

end
