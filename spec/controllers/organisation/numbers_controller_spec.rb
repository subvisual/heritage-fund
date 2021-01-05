require "rails_helper"

RSpec.describe Organisation::NumbersController do
  login_user

  describe "GET #show" do
    it "should render the page successfully for a valid organisation" do
      get :show,
        params: {organisation_id: subject.current_user.organisations.first.id}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid organisation" do
      get :show, params: {organisation_id: "invalid"}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end
  end

  describe "PUT #update" do
    it "should raise an exception based on strong params validation if no " \
       "params are passed" do
      expect {
        put :update,
          params: {organisation_id: subject.current_user.organisations.first.id}
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(:organisation_signatories)
      }.to raise_error(
        ActionController::ParameterMissing,
        "param is missing or the value is empty: organisation"
      )
    end

    it "should raise an exception based on strong params validation if an " \
       "empty organisation param is passed" do
      expect {
        put :update,
          params: {
            organisation_id: subject.current_user.organisations.first.id,
            organisation: {}
          }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(:organisation_signatories)
      }.to raise_error(
        ActionController::ParameterMissing,
        "param is missing or the value is empty: organisation"
      )
    end

    it "should successfully redirect to about if empty charity_number " \
       "and company_number params are passed" do
      put :update,
        params: {
          organisation_id: subject.current_user.organisations.first.id,
          organisation: {
            charity_number: "",
            company_number: ""
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
        postcode_path("organisation",
          subject.current_user.organisations.first.id)
      )
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end

    it "should successfully redirect to about if populated charity_number " \
       "and company_number params are passed" do
      put :update,
        params: {
          organisation_id: subject.current_user.organisations.first.id,
          organisation: {
            charity_number: "CHNO12345",
            company_number: "CONO54321"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
        postcode_path("organisation",
          subject.current_user.organisations.first.id)
      )
      expect(assigns(:organisation).errors.empty?).to eq(true)
      expect(assigns(:organisation).charity_number).to eq("CHNO12345")
      expect(assigns(:organisation).company_number).to eq("CONO54321")
    end
  end
end
