require "rails_helper"

RSpec.describe Project::DatesController do
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

    it "should raise a ParameterMissing exception if no project param is " \
       "passed" do

      expect {
        put :update,
            params: { project_id: project.id }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should raise a ParameterMissing exception if an empty project param " \
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

    it "should re-render the page when empty params are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "",
                  start_date_month: "",
                  start_date_year: "",
                  end_date_day: "",
                  end_date_month: "",
                  end_date_year: ""
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)

      expect(
          assigns(:project).errors.messages[:start_date_day][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date_day.blank"))
      expect(
          assigns(:project).errors.messages[:start_date_month][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date_month.blank"))
      expect(
          assigns(:project).errors.messages[:start_date_year][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date_year.blank"))

      expect(
          assigns(:project).errors.messages[:end_date_day][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date_day.blank"))
      expect(
          assigns(:project).errors.messages[:end_date_month][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date_month.blank"))
      expect(
          assigns(:project).errors.messages[:end_date_year][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date_year.blank"))

    end

    it "should re-render the page when invalid date params are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "35",
                  start_date_month: "1",
                  start_date_year: "2020",
                  end_date_day: "35",
                  end_date_month: "1",
                  end_date_year: "2020"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)

      expect(
          assigns(:project).errors.messages[:start_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date.invalid"))
      expect(
          assigns(:project).errors.messages[:end_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date.invalid"))

    end

    it "should re-render the page when a start date which occurs after the " \
       "end date is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "31",
                  start_date_month: "12",
                  start_date_year: "2035",
                  end_date_day: "31",
                  end_date_month: "1",
                  end_date_year: "2035"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)

      expect(
          assigns(:project).errors.messages[:start_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date.after_end_date"))
      expect(
          assigns(:project).errors.messages[:end_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date.before_start_date"))

    end

    it "should re-render the page when start and end dates which occur in " \
       "the past are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "31",
                  start_date_month: "1",
                  start_date_year: "1990",
                  end_date_day: "31",
                  end_date_month: "3",
                  end_date_year: "1999"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)

      expect(subject.request.flash[:start_date_day]).to eq("31")
      expect(subject.request.flash[:start_date_month]).to eq("1")
      expect(subject.request.flash[:start_date_year]).to eq("1990")
      expect(subject.request.flash[:end_date_day]).to eq("31")
      expect(subject.request.flash[:end_date_month]).to eq("3")
      expect(subject.request.flash[:end_date_year]).to eq("1999")

      expect(
          assigns(:project).errors.messages[:start_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.start_date.in_past"))
      expect(
          assigns(:project).errors.messages[:end_date][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.end_date.in_past"))

    end

    it "should re-render the page with a flash message when start and end " \
       "dates which have a gap of a year or longer are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "31",
                  start_date_month: "1",
                  start_date_year: "2030",
                  end_date_day: "31",
                  end_date_month: "3",
                  end_date_year: "2031"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(true)

      expect(subject.request.flash[:date_warning])
          .to eq(I18n.t("project.dates.flash_warning"))

    end

    it "should successfully update and redirect when valid params are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  start_date_day: "31",
                  start_date_month: "1",
                  start_date_year: "2030",
                  end_date_day: "31",
                  end_date_month: "3",
                  end_date_year: "2030"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_location)

      expect(assigns(:project).errors.empty?).to eq(true)

      expect(assigns(:project).start_date.to_s).to eq("2030-01-31")
      expect(assigns(:project).end_date.to_s).to eq("2030-03-31")

    end

  end

end
