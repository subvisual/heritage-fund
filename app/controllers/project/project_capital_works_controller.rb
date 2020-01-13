class Project::ProjectCapitalWorksController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating capital works for project ID: #{@project.id}"

    @project.validate_capital_work = true

    if params[:project].present?
      @project.validate_capital_work_file = true if params[:project][:capital_work] == "true"
    end

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished updating capital works for project ID: #{@project.id}"

      if params[:project][:capital_work_file].present?
        redirect_to three_to_ten_k_project_capital_works_get_path
      else
        redirect_to three_to_ten_k_project_permission_get_path
      end

    else

      respond_to do |format|
        format.html {render :show}
        format.js {render :show}
      end

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {capital_work: ""}})
    end

    params.require(:project).permit(:capital_work, :capital_work_file)

  end

end
