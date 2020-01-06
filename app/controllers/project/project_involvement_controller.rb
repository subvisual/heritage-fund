class Project::ProjectInvolvementController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating project involvement_description for project ID: #{@project.id}"

    @project.validate_involvement_description = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished setting project involvement_description for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_other_outcomes_get

    else

      logger.debug "Validation failed when updating project involvement_description for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {involvement_description: ""}})
    end

    params.require(:project).permit(:involvement_description)

  end

end
