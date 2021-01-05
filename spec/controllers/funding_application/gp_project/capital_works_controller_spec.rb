require 'rails_helper'

RSpec.describe FundingApplication::GpProject::CapitalWorksController do
  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe 'GET #show' do
    it 'should render the page successfully for a valid project' do
      get :show, params: { application_id: funding_application.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it 'should redirect to root for an invalid project' do
      get :show, params: { application_id: 'invalid' }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end
  end

  describe 'PUT #update' do
    it 'should re-render the page if no params are passed' do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: { application_id: funding_application.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:capital_work][0]
      ).to eq(I18n.t('activerecord.errors.models.project.attributes.capital_work.inclusion'))
    end

    it 'should re-render the page if an empty capital_work param is passed' do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
            application_id: funding_application.id,
            capital_work: ''
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:capital_work][0]
      ).to eq(I18n.t('activerecord.errors.models.project.attributes.capital_work.inclusion'))
    end

    it 'should re-render the page if an invalid capital_work param is passed' do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
            application_id: funding_application.id,
            capital_work: 'invalid'
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:capital_work][0]
      ).to eq(I18n.t('activerecord.errors.models.project.attributes.capital_work.inclusion'))
    end

    it 'should successfully update and redirect to the next page if a valid ' \
       'capital_work param is passed' do
      put :update, params: {
        application_id: funding_application.id,
        project: {
          capital_work: 'true'
        }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_permission)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.capital_work).to eq(true)
    end

    it 'should successfully update and redirect to the same page if valid ' \
       'capital_work and capital_work_file params are passed' do
      put :update, params: {
        application_id: funding_application.id,
        project: {
          capital_work: 'true',
          capital_work_file: Rack::Test::UploadedFile.new(
            Rails.root + 'spec/fixtures/files/example.txt'
          )
        }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_capital_works)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.capital_work).to eq(true)
    end
  end
end
