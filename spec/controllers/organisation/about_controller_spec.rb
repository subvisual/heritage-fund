require "rails_helper"

describe Organisation::AboutController do
  login_user

  describe "GET #show_postcode_lookup" do

    it "should render the postcode lookup page successfully for a valid " \
       "organisation" do
      get :show_postcode_lookup,
          params: { organisation_id: subject.current_user.organisation.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:postcode_lookup)
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid organisation" do
      get :show_postcode_lookup, params: { organisation_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "GET #show" do

    it "should render the full organisation name and address page " \
       "successfully for a valid organisation" do
      get :show,
          params: { organisation_id: subject.current_user.organisation.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:about)
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid organisation" do
      get :show, params: { organisation_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "PUT #update" do

    it "should redirect to root for an invalid organisation" do
      put :update, params: { organisation_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

    it "should raise an exception based on strong params validation if no " \
        "params are passed" do
      expect {
        put :update,
            params: {
                organisation_id: subject.current_user.organisation.id
            }
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
                organisation_id: subject.current_user.organisation.id,
                organisation: {}
            }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: organisation"
           )
    end

    it "should re-render the page with errors present if mandatory empty " \
       "params are passed" do

      expect(subject).to \
        receive(:log_errors).with(subject.current_user.organisation)

      put :update,
          params: {
              organisation_id: subject.current_user.organisation.id,
              organisation: {
                  name: "test"
              }
          }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:about)

      expect(assigns(:organisation).errors.empty?).to eq(false)

      expect(assigns(:organisation).errors[:line1][0])
          .to eq("Enter the first line of your organisation's address")
      expect(assigns(:organisation).errors[:townCity][0])
          .to eq("Enter the town or city where your organisation is located")
      expect(assigns(:organisation).errors[:county][0])
          .to eq("Enter the county where your organisation is located")
      expect(assigns(:organisation).errors[:postcode][0])
          .to eq("Enter the postcode where your organisation is located")
    end

    it "should successfully redirect if all mandatory params are passed" do
      put :update,
          params: {
              organisation_id: subject.current_user.organisation.id,
              organisation: {
                  name: "test name",
                  line1: "10 Downing Street",
                  line2: "Westminster",
                  line3: "test line 3",
                  townCity: "London",
                  county: "London",
                  postcode: "SW1A 2AA"
              }
          }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:organisation_mission)

      expect(assigns(:organisation).errors.empty?).to eq(true)

      expect(assigns(:organisation).name).to eq("test name")
      expect(assigns(:organisation).line1).to eq("10 Downing Street")
      expect(assigns(:organisation).line2).to eq("Westminster")
      expect(assigns(:organisation).line3).to eq("test line 3")
      expect(assigns(:organisation).townCity).to eq("London")
      expect(assigns(:organisation).county).to eq("London")
      expect(assigns(:organisation).postcode).to eq("SW1A 2AA")
    end

  end

  describe "POST #assign_address_attributes" do

    it "should successfully render the :about template and assign " \
       "organisation address attributes" do

      ideal_postcode_stub_requests

      post :assign_address_attributes,
           params: {
               organisation_id: subject.current_user.organisation.id,
               address: "25962215"
           }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:about)

      expect(assigns(:organisation).errors.empty?).to eq(true)

      expect(assigns(:organisation).line1).to eq("4 Barons Court Road")
      expect(assigns(:organisation).line2).to eq("")
      expect(assigns(:organisation).line3).to eq("")
      expect(assigns(:organisation).townCity).to eq("LONDON")
      expect(assigns(:organisation).county).to eq("London")
      expect(assigns(:organisation).postcode).to eq("W14 9DT")

    end

  end

end
