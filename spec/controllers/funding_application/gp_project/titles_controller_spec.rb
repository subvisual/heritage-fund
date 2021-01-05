require 'rails_helper'

RSpec.describe FundingApplication::GpProject::TitlesController do
  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe 'GET #show' do
    it 'should render the page successfully for a valid project' do
      get :show,
          params: { application_id: funding_application.id }
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
    it 'should raise a ParameterMissing error if no params are passed' do
      expect {
        put :update, params: {
          application_id: funding_application.id
        }
      }.to raise_error(
        ActionController::ParameterMissing,
        'param is missing or the value is empty: project'
      )
    end

    it 'should raise a ParameterMissing error if an empty project param ' \
       'is passed' do
      expect {
        put :update, params: {
          application_id: funding_application.id,
          project: {}
        }
      }.to raise_error(
        ActionController::ParameterMissing,
        'param is missing or the value is empty: project'
      )
    end

    it 'should re-render the page if an empty project_title param is passed' do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update, params: {
        application_id: funding_application.id,
        project: {
          project_title: ''
        }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:project_title][0]
      ).to eq(I18n.t('activerecord.errors.models.project.attributes.project_title.blank'))
    end

    it 'should re-render the page if project_title param over 255 characters ' \
       'in length is passed' do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update, params: {
        application_id: funding_application.id,
        project: {
          project_title: '0' * 256
        }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:project_title][0]
      ).to eq(I18n.t('activerecord.errors.models.project.attributes.project_title.too_long'))
    end

    it 'should successfully update if a valid param is passed' do
      put :update, params: {
        application_id: funding_application.id,
        project: {
          project_title: 'Test project title'
        }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_key_dates)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.project_title).to eq('Test project title')
    end
  end
end
