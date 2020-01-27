class Project::ProjectVolunteersController < ApplicationController
  include ProjectContext

  def put

    # Empty flash values to ensure that we don't redisplay them unnecessarily
    flash[:description] = ""
    flash[:hours] = ""

    logger.debug "Adding volunteer for project ID: #{@project.id}"

    @project.validate_volunteers = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Successfully added volunteer for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_volunteers_path

    else

      logger.debug "Validation failed when adding volunteer for project ID: #{@project.id}"

      # Store flash values to display them again when re-rendering the page
      flash[:description] = params['project']['volunteers_attributes']['0']['description']
      flash[:hours] = params['project']['volunteers_attributes']['0']['hours']

      render :show

    end

  end

  def delete

    logger.debug "User has selected to delete volunteer cost ID: #{params[:volunteer_id]}" \
                    " from project ID: #{@project.id}"

    volunteer = Volunteer.find(params[:volunteer_id])

    logger.debug "Deleting volunteer ID: #{volunteer.id}"

    volunteer.destroy if volunteer.project_id == @project.id

    logger.debug "Finished deleting volunteer ID: #{volunteer.id}"

    redirect_to three_to_ten_k_project_volunteers_path

  end

  private
  def project_params
    params.require(:project).permit(volunteers_attributes: [:description, :hours])
  end

end
