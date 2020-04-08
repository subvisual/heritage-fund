class Project::DifferenceController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the difference attribute of a project, redirecting to
  # :three_to_ten_k_project_how_does_your_project_matter if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating difference for project ID: #{@project.id}"

    @project.validate_difference = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating difference for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_how_does_your_project_matter

    else

      logger.info "Validation failed when attempting to update difference " \
                  "for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {difference: ""}})
    end

    params.require(:project).permit(:difference)

  end

end
