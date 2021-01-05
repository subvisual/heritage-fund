class FundingApplication::GpProject::VolunteersController < ApplicationController
  include ObjectErrorsLogger
  include FundingApplicationContext

  # This method adds a volunteer to a project, redirecting back to
  # :funding_application_gp_project_volunteers if successful and
  # re-rendering :show method if unsuccessful
  def update
    # Empty flash values to ensure that we don't redisplay them unnecessarily
    flash[:description] = ""
    flash[:hours] = ""

    logger.info "Adding volunteer for project ID: #{@funding_application.project.id}"

    @funding_application.project.validate_volunteers = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Successfully added volunteer for project ID: #{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_volunteers

    else

      logger.info "Validation failed when adding volunteer for project ID: " \
                  "#{@funding_application.project.id}"

      log_errors(@funding_application.project)

      # Store flash values to display them again when re-rendering the page
      flash[:description] =
        params["project"]["volunteers_attributes"]["0"]["description"]
      flash[:hours] = params["project"]["volunteers_attributes"]["0"]["hours"]

      render :show

    end
  end

  # This method deletes a project volunteer, redirecting back to
  # :funding_application_gp_project_volunteers once completed
  def delete
    logger.info "User has selected to delete volunteer ID: " \
                "#{params[:volunteer_id]} from project ID: #{@funding_application.project.id}"

    volunteer = @funding_application.project.volunteers.find(params[:volunteer_id])

    logger.info "Deleting volunteer ID: #{volunteer.id}"

    volunteer.destroy

    logger.info "Finished deleting volunteer ID: #{volunteer.id}"

    redirect_to :funding_application_gp_project_volunteers
  end

  private

  def project_params
    params.require(:project).permit(
      volunteers_attributes: [:description, :hours]
    )
  end
end
