class Project::PermissionController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  def update

    logger.info "Updating project permission attributes for project ID: " \
                "#{@project.id}"

    @project.validate_permission_type = true

    if params[:project].present?

      if params[:project][:permission_type].present?

        if params[:project][:permission_type] == "yes"

          @project.permission_description =
              params[:project][:permission_description_yes].present? ?
                  params[:project][:permission_description_yes] : nil

          @project.validate_permission_description_yes = true

        end

        if params[:project][:permission_type] == "x_not_sure"

          @project.permission_description =
              params[:project][:permission_description_x_not_sure].present? ?
                  params[:project][:permission_description_x_not_sure] : nil

          @project.validate_permission_description_x_not_sure = true

        end

      end

    end

    @project.update(project_params)

    if @project.valid?

      @project.save

      logger.info "Finished updating project permission attributes for " \
                  "project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_difference_get

    else

      logger.info "Validation failed when attempting to update permission " \
                  "attributes for project ID: #{@project.id}"

      log_errors(@project)

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
