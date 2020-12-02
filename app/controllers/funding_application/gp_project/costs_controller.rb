class FundingApplication::GpProject::CostsController < ApplicationController
  include FundingApplicationContext, ObjectErrorsLogger
  before_action :remove_flash_values

  # This method is used to control page flow based on whether a not a
  # user has added costs to a project
  def validate_and_redirect

    logger.info "Confirming that user has added costs for project ID: " \
                 "#{@funding_application.project.id}"

    @funding_application.project.validate_has_associated_project_costs = true

    if @funding_application.project.valid?

      logger.info "Costs found for project ID: #{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_are_you_getting_cash_contributions

    else

      logger.info "No project costs found for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end

  end

  # This method adds a cost to a project, redirecting back to
  # :three_to_ten_k_project_project_costs if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Adding cost for project ID: #{@funding_application.project.id}"

    # Empty flash values to ensure that we don't redisplay them unnecessarily
    remove_flash_values

    @funding_application.project.validate_project_costs = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Succesfully added project cost for project ID: " \
                  "#{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_costs

    else

      logger.info "Validation failed when attempting to add cost for project " \
                  "ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      # Store flash values to display them again when re-rendering the page
      flash[:description] =
          params['project']['project_costs_attributes']['0']['description']
      flash[:amount] =
          params['project']['project_costs_attributes']['0']['amount']
      flash[:cost_type] =
          params['project']['project_costs_attributes']['0']['cost_type']

      render :show

    end

  end

  # This method deletes a project cost, redirecting back to
  # :three_to_ten_k_project_project_costs once completed.
  # If no cost is found, then an ActiveRecord::RecordNotFound exception is
  # raised
  def delete

      logger.info "User has selected to delete cost ID: " \
                  "#{params[:project_cost_id]} from project ID: " \
                  "#{@funding_application.project.id}"

      cost = @funding_application.project.project_costs.find(params[:project_cost_id])

      logger.info "Deleting cost ID: #{cost.id}"

      cost.destroy

      logger.info "Finished deleting cost ID: #{cost.id}"

      redirect_to :funding_application_gp_project_costs

  end

  private

  def project_params
    params.require(:project).permit(project_costs_attributes: [:description, :amount, :cost_type])
  end

  def remove_flash_values
    flash[:description] = ""
    flash[:amount] = ""
    flash[:cost_type] = ""
  end

end
