class Project::CapitalWorksController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method is used to set the @has_file_upload instance variable before
  # rendering the :show template. This is used within the
  # _direct_file_upload_hooks partial
  def show
    @has_file_upload = true
  end

  # This method updates the capital_work and capital_work_file attributes of a
  # project, redirecting to :three_to_ten_k_project_permission_get if successful
  # and re-rendering :show method if unsuccessful
  def update

    logger.info "Updating capital_work for project ID: #{@project.id}"

    @project.validate_capital_work = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating capital_work for project ID: " \
                   "#{@project.id}"

      # Redirect the user back to the same page if they were uploading a
      # capital work file - this is so that we can display the file back to
      # the user so they can check that they have uploaded the correct file
      if params[:project][:capital_work_file].present?
        redirect_to :three_to_ten_k_project_capital_works_get
      else
        redirect_to :three_to_ten_k_project_permission_get
      end

    else

      logger.info "Validation failed when attempting to update capital_work " \
                  "for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({ project: { capital_work: "" } })
    end

    params.require(:project).permit(:capital_work, :capital_work_file)

  end

end
