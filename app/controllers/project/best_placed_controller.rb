class Project::BestPlacedController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the best_placed_description attribute of a project,
  # redirecting to :three_to_ten_k_project_involvement_get if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating best_placed_description for project ID: " \
                 "#{@project.id}"

    @project.validate_best_placed_description = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating best_placed_description for project " \
                   "ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_involvement_get

    else

      logger.info "Validation failed when attempting to update " \
                  "best_placed_description for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {best_placed_description: ""}})
    end

    params.require(:project).permit(:best_placed_description)

  end
  
end
