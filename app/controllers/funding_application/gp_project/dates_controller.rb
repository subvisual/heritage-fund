class FundingApplication::GpProject::DatesController < ApplicationController
  include FundingApplicationContext, ObjectErrorsLogger

  def update

    logger.info "Updating start_date and end_date for project ID: " \
                "#{@funding_application.project.id}"

    @funding_application.project.validate_start_and_end_dates = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      start_date = Date.new(params[:project][:start_date_year].to_i,
                            params[:project][:start_date_month].to_i,
                            params[:project][:start_date_day].to_i)

      end_date = Date.new(params[:project][:end_date_year].to_i,
                          params[:project][:end_date_month].to_i,
                          params[:project][:end_date_day].to_i)

      @funding_application.project.start_date = start_date
      @funding_application.project.end_date = end_date

      # Only display the project length warning if we haven't displayed
      # it before, which we can determine by checking the FlashHash
      if is_project_length_greater_than_one_year(start_date, end_date) &&
          flash.empty?

        store_values_in_flash

        logger.debug "Displaying project length warning for project ID: " \
                     "#{@funding_application.project.id}"

        flash[:date_warning] = I18n.t("project.dates.flash_warning")

        render :show

      else

        # Ensure that we've cleared out the FlashHash to avoid
        # unnecessarily re-displaying the project length warning
        flash[:date_warning] = ""

        @funding_application.project.save

        logger.info "Successfully update start_date and end_date for project " \
                    "ID: #{@funding_application.project.id}"

        redirect_to :funding_application_gp_project_location

      end

    else

      logger.info "Validation failed when attempting to update start_date " \
                  "and end_date for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      store_values_in_flash

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(
        :start_date_day,
        :start_date_month,
        :start_date_year,
        :end_date_day,
        :end_date_month,
        :end_date_year
    )
  end

  # This method checks to determine whether or not the project length
  # is greater than one year
  def is_project_length_greater_than_one_year(first_date, second_date)

    logger.debug "Calculating length of project in days for project ID: #{@funding_application.project.id}"

    length_in_days = (second_date - first_date).to_i

    logger.debug "Project length in days of #{length_in_days} for project ID: #{@funding_application.project.id}"

    length_in_days > 365

  end

  # Temporarily stores values in FlashHash to redisplay if there
  # have been any errors - this is necessary as we don't have
  # model attributes that are persistent for the individual date
  # items.
  def store_values_in_flash

    params[:project].each do | key, value |
      flash[key] = value.empty? ? "" : value
    end

  end

end
