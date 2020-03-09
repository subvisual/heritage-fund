class Project::VolunteersController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method adds a volunteer to a project, redirecting back to
  # :three_to_ten_k_project_volunteers if successful and
  # re-rendering :show method if unsuccessful
  def update

    # Empty flash values to ensure that we don't redisplay them unnecessarily
    flash[:description] = ""
    flash[:hours] = ""

    logger.info "Adding volunteer for project ID: #{@project.id}"

    @project.validate_volunteers = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Successfully added volunteer for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_volunteers

    else

      logger.info "Validation failed when adding volunteer for project ID: " \
                  "#{@project.id}"

      log_errors(@project)

      # Store flash values to display them again when re-rendering the page
      flash[:description] =
          params['project']['volunteers_attributes']['0']['description']
      flash[:hours] = params['project']['volunteers_attributes']['0']['hours']

      render :show

    end

  end

  # This method deletes a project volunteer, redirecting back to
  # :three_to_ten_k_project_volunteers once completed
  def delete

    logger.info "User has selected to delete volunteer ID: " \
                "#{params[:volunteer_id]} from project ID: #{@project.id}"

    volunteer = Volunteer.find_by(id: params[:volunteer_id])

    if volunteer.present?

      logger.info "Deleting volunteer ID: #{volunteer.id}"

      volunteer.destroy if volunteer.project_id == @project.id

      logger.info "Finished deleting volunteer ID: #{volunteer.id}"

    else

      logger.info "No volunteer found with ID: #{params[:volunteer_id]}, " \
                  "no deletion carried out"

    end

    redirect_to :three_to_ten_k_project_volunteers

  end

  private
  def project_params
    params.require(:project).permit(
        volunteers_attributes: [:description, :hours]
    )
  end

end
