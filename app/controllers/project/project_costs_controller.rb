class Project::ProjectCostsController < ApplicationController
  include ProjectContext
  before_action :remove_flash_values

  def validate_and_redirect

    logger.debug "Confirming that user has added project costs for project ID: #{@project.id}"

    @project.validate_has_associated_project_costs = true

    if @project.valid?

      logger.debug "Project costs found for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_cash_contributions_question_get_url

    else

      logger.debug "No project costs found for project ID: #{@project.id}"

      render :show

    end

  end

  def update

    logger.debug "Updating project costs for project ID: #{@project.id}"

    # Empty flash values to ensure that we don't redisplay them unnecessarily
    remove_flash_values

    @project.validate_project_costs = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished adding project cost for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_project_costs_path

    else

      logger.debug "Validation failed when adding project cost for project ID: #{@project.id}"

      # Store flash values to display them again when re-rendering the page
      flash[:description] = params['project']['project_costs_attributes']['0']['description']
      flash[:amount] = params['project']['project_costs_attributes']['0']['amount']
      flash[:cost_type] = params['project']['project_costs_attributes']['0']['cost_type']

      render :show

    end

  end

  private
  def project_params
    params.require(:project).permit(project_costs_attributes: [:description, :amount, :cost_type])
  end

  private
  def remove_flash_values
    flash[:description] = ""
    flash[:amount] = ""
    flash[:cost_type] = ""
  end
end
