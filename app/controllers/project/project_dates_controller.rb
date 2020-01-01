class Project::ProjectDatesController < ApplicationController
  include ProjectHelper
  before_action :authenticate_user!, :set_project

  def show
  end

  def update

    logger.debug "Updating project start and end dates for project ID: #{@project.id}"

    @project.validate_start_and_end_dates = true

    @project.update(project_params)

    if @project.valid?

      start_date = Date.new(params[:project][:start_date_year].to_i,
                            params[:project][:start_date_month].to_i,
                            params[:project][:start_date_day].to_i)

      end_date = Date.new(params[:project][:end_date_year].to_i,
                          params[:project][:end_date_month].to_i,
                          params[:project][:end_date_day].to_i)

      @project.start_date = start_date
      @project.end_date = end_date

      # Only display the project length warning if we haven't displayed
      # it before, which we can determine by checking the FlashHash
      if is_project_length_greater_than_one_year(start_date, end_date) && flash.empty?

        logger.debug "Displaying project length warning for project ID: #{@project.id}"

        flash.notice = "You can still submit your application if the start " +
            "and end dates are over one year but this can affect assessment."

        render :show

      else

        # Ensure that we've cleared out the FlashHash to avoid
        # unnecessarily re-displaying the project length warning
        flash.discard

        @project.save

        logger.debug "Finished updating start and end dates for project ID: #{@project.id}"

        redirect_to three_to_ten_k_project_location_get_path(@project.id)

      end

    else

      logger.debug "Start or end date validation failed for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(:start_date_day,
                                    :start_date_month,
                                    :start_date_year,
                                    :end_date_day,
                                    :end_date_month,
                                    :end_date_year)
  end

  # This method checks to determine whether or not the project length
  # is greater than one year
  def is_project_length_greater_than_one_year(first_date, second_date)

    logger.debug "Calculating length of project in days for project ID: #{@project.id}"

    length_in_days = (second_date - first_date).to_i

    logger.debug "Project length in days of #{length_in_days} for project ID: #{@project.id}"

    if length_in_days > 365
      return true
    else
      return false
    end

  end

end
