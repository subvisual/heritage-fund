class ReleasedFormController < ApplicationController
    protect_from_forgery with: :null_session
    def receive
       @project = Project.find(params[:ApplicationId])
        if params[:Status] == 'Awarded' && !params[:ApprovedbyFinance]
            @project.released_forms.create(payload: request.raw_post, form_type: 'permission-to-start')
        end
    end
end
