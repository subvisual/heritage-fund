class Project::AccountsController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  def update

    logger.info "Updating accounts_files for project ID: #{@project.id}"

    @project.update(project_params)

    @project.validate_accounts_files = true

    if @project.valid?

      logger.info "Finished updating accounts_files for project ID: " \
                  "#{@project.id}"

      redirect_to :three_to_ten_k_project_accounts

    else

      logger.info "Validation failed when attempting to update " \
                  "accounts_files for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({ project: { accounts_files: nil }})
    end

    params.require(:project).permit(:accounts_files => [])

  end

end
