require "rails_helper"

describe Project::CheckAnswersController do
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

    it "should re-render the page if mandatory project fields have not been " \
       "populated" do

      put :update,
          params: {
              project_id: project.id
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.description.blank"))
      expect(assigns(:project).errors.messages[:involvement_description][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.involvement_description.blank"))
      expect(assigns(:project).errors.messages[:project_costs][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.project_costs.blank"))

    end

    it "should redirect if mandatory project attributes are populated, and " \
       "the org_type is 'registered_company'" do

      subject.current_user.organisation.update(
          org_type: "registered_company"
      )

      project.update(
          description: "Test",
          involvement_description: "Test",
      )

      project.project_costs << create(
          :project_cost,
          project_id: project.id,
          cost_type: "new_staff",
          description: "Test",
          amount: 5000
      )

      put :update,
          params: {
              project_id: project.id
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_confirm_declaration_get)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

    it "should redirect if mandatory project attributes are populated, and " \
       "the org_type is 'individual_private_owner_of_heritage'" do

      subject.current_user.organisation.update(
          org_type: "individual_private_owner_of_heritage"
      )

      project.update(
          description: "Test",
          involvement_description: "Test",
          )

      project.project_costs << create(
          :project_cost,
          project_id: project.id,
          cost_type: "new_staff",
          description: "Test",
          amount: 5000
      )

      put :update,
          params: {
              project_id: project.id
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_confirm_declaration_get)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

    it "should redirect if mandatory project attributes are populated, and " \
       "the org_type is not 'registered_company' or " \
       "'individual_private_owner_of_heritage'" do

      subject.current_user.organisation.update(
          org_type: "registered_charity"
      )

      project.update(
          description: "Test",
          involvement_description: "Test",
          )

      project.project_costs << create(
          :project_cost,
          project_id: project.id,
          cost_type: "new_staff",
          description: "Test",
          amount: 5000
      )

      put :update,
          params: {
              project_id: project.id
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:three_to_ten_k_project_governing_docs_get)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

  end

end

