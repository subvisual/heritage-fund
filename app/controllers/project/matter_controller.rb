class Project::MatterController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  def update

    logger.info "Updating matter for project ID: #{@project.id}"

    @project.validate_matter = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating matter for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_your_project_heritage

    else

      logger.info "Validation failed when attempting to update matter for " \
                  "project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {matter: ""}})
    end

    params.require(:project).permit(:matter)

  end

end
