require 'rails_helper'

RSpec.describe FundingApplication::GpProject::LocationController do

  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe "GET #show" do
    it "should render the page successfully for a valid project" do
      get :show,
          params: {application_id: funding_application.id}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show, params: { application_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end



  describe "PUT #update" do

    it "should re-render the page with error if no location option selected" do
      put :update,
        params: {application_id: funding_application.id, project: {}}
        expect(response).to have_http_status(:success)
      expect(
          assigns(:funding_application).project.errors.messages[:same_location][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.same_location.blank"))
    end

    it "should re-render the page with error if no project param passed in" do
      put :update,
        params: {application_id: funding_application.id}
        expect(response).to have_http_status(:success)
      expect(
          assigns(:funding_application).project.errors.messages[:same_location][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.same_location.blank"))
    end

    it "updates project address to match organisation address if same location selected" do
      funding_application.organisation.update(line1: 'line1', line2: 'line2', line3: 'line3', townCity: 'townCity', county: 'county', postcode: 'postcode')
      put :update,
          params: {application_id: funding_application.id, project: {same_location: 'yes'}}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_description)
      Project.find(funding_application.project.id) do |p|
        expect(p.line1).to eq('line1')
        expect(p.line2).to eq('line2')
        expect(p.line3).to eq('line3')
        expect(p.townCity).to eq('townCity')
        expect(p.county).to eq('county')
        expect(p.postcode).to eq('postcode')
      end
    end

    it "redirects to address page if same location is not selected" do
      put :update,
          params: {application_id: funding_application.id, project: {same_location: 'no'}}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              redirect_to postcode_path 'project', funding_application.project.id
                          )
    end

  end
end