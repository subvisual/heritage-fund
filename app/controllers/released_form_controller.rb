class ReleasedFormController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.x.consumer.username, password: Rails.configuration.x.consumer.password

    protect_from_forgery with: :null_session
    def receive
       @project = Project.find(params[:ApplicationId])
       if params[:GrantDecision] == 'Awarded' && !params[:ApprovedbyFinance]
            @project.released_forms.create(payload: request.raw_post, form_type: :permission_to_start)
        end
       if params[:ApprovedbyFinance]
            @project.released_forms.create(payload: request.raw_post, form_type: :completion_report)
        end
    end
end
