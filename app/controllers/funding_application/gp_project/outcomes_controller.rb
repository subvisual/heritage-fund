class FundingApplication::GpProject::OutcomesController < ApplicationController
  include ObjectErrorsLogger
  include FundingApplicationContext

  def update
    logger.info "Updating outcome attributes for project ID: #{@funding_application.project.id}"

    remove_outcome_descriptions

    @funding_application.project.validate_other_outcomes = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Finished updating outcome attributes for project " \
                  "ID: #{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_costs

    else

      logger.info "Validation failed when attempting to update outcome " \
                  "attributes for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end
  end

  private

  def project_params
    params.require(:project).permit(
      :outcome_2,
      :outcome_3,
      :outcome_4,
      :outcome_5,
      :outcome_6,
      :outcome_7,
      :outcome_8,
      :outcome_9,
      :outcome_2_description,
      :outcome_3_description,
      :outcome_4_description,
      :outcome_5_description,
      :outcome_6_description,
      :outcome_7_description,
      :outcome_8_description,
      :outcome_9_description
    )
  end

  # This method sets outcome description parameters to an empty string
  # if the outcome has been unchecked on the page. This is necessary
  # as unchecking a checkbox on the page does not remove the value
  # from the corresponding conditional textfield, meaning that it still
  # gets passed in the params.
  def remove_outcome_descriptions
    if params[:project].present?
      (2..9).each do |i|
        if params[:project]["outcome_#{i}"] == "false"
          params[:project]["outcome_#{i}_description"] = ""
        end
      end
    end
  end
end
