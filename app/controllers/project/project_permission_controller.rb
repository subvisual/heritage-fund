class Project::ProjectPermissionController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating project permission type/description for project ID: " +
                     "#{@project.id}"

    @project.validate_permission_type = true

    if params[:project][:permission_type] == "yes"
      @project.permission_description = params[:project][:permission_description_yes]
      @project.validate_permission_description_yes = true
    end

    if params[:project][:permission_type] == "not_sure"
      @project.permission_description = params[:project][:permission_description_not_sure]
      @project.validate_permission_description_not_sure = true
    end

    @project.update(project_params)

    if @project.valid?

      if params[:project][:permission_type] == "yes"
        @project.permission_description = params[:project][:permission_description_yes]
      end

      if params[:project][:permission_type] == "not_sure"
        @project.permission_description = params[:project][:permission_description_not_sure]
      end

      @project.save

      logger.debug "Finished updating project permission type/description for project ID: " +
                       "#{@project.id}"

      redirect_to three_to_ten_k_project_difference_get_path

    else

      logger.debug "Validation failed when updating project permission type/description " +
                       "for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    params.require(:project).permit(
        :permission_type,
        :permission_description_yes,
        :permission_description_not_sure
    )

  end

end
