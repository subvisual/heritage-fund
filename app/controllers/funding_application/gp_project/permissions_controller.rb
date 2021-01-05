class FundingApplication::GpProject::PermissionsController < ApplicationController
  include ObjectErrorsLogger
  include FundingApplicationContext

  def update
    logger.info 'Updating project permission attributes for project ID: ' \
                "#{@funding_application.project.id}"

    @funding_application.project.validate_permission_type = true

    if params[:project].present?

      if params[:project][:permission_type].present?

        if params[:project][:permission_type] == 'yes'

          @funding_application.project.permission_description =
            params[:project][:permission_description_yes].present? ?
                params[:project][:permission_description_yes] : nil

          @funding_application.project.validate_permission_description_yes = true

        end

        if params[:project][:permission_type] == 'x_not_sure'

          @funding_application.project.permission_description =
            params[:project][:permission_description_x_not_sure].present? ?
                params[:project][:permission_description_x_not_sure] : nil

          @funding_application.project.validate_permission_description_x_not_sure = true

        end

      end

    end

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      @funding_application.project.save

      logger.info 'Finished updating project permission attributes for ' \
                  "project ID: #{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_difference

    else

      logger.info 'Validation failed when attempting to update permission ' \
                  "attributes for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end
  end

  private

  def project_params
    params.require(:project).permit(
      :permission_type,
      :permission_description_yes,
      :permission_description_x_not_sure
    )
  end
end
