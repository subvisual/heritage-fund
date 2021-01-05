require "rails_helper"

RSpec.describe HealthController do
  describe "GET #health" do
    it "should return a successful response" do
      get :status
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["status"]).to eq("OK")
    end
  end
end
