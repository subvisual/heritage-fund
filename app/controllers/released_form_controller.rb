class ReleasedFormController < ApplicationController
    protect_from_forgery with: :null_session
    def receive
       @project = Project.find(params[:ApplicationId])
       if params[:GrantDecision] == 'Awarded' && !params[:ApprovedbyFinance]
            @project.released_forms.create(payload: request.raw_post, form_type: 'permission-to-start')
        end
       if params[:ApprovedbyFinance]
            @project.released_forms.create(payload: request.raw_post, form_type: 'completion-report')
        end
    end
end
