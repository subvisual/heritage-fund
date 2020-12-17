# Controller for the Pre-application 'Start' page
class PreApplication::ExpressionOfInterest::FeasibilityOrOptionsWorkController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger

  # This method updates the feasibility_or_options_work attribute of a pa_expression_of_interest,
  # redirecting to :pre_application_expression_of_interest_project_timescales if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating feasibility_or_options_work for ' \
                "pa_expression_of_interest ID: #{@pre_application.pa_expression_of_interest.id}"

    @pre_application.pa_expression_of_interest.validate_feasibility_or_options_work = true

    @pre_application.pa_expression_of_interest.update(pa_expression_of_interest_params)

    if @pre_application.pa_expression_of_interest.valid?

      logger.info 'Finished updating feasibility_or_options_work for pa_expression_of_interest ID: ' \
                  "#{@pre_application.pa_expression_of_interest.id}"

      redirect_to(:pre_application_expression_of_interest_timescales)

    else

      logger.info 'Validation failed when attempting to update feasibility_or_options_work ' \
                  " for pa_expression_of_interest ID: #{@pre_application.pa_expression_of_interest.id}"

      log_errors(@pre_application.pa_expression_of_interest)

      render(:show)

    end
  
  end

  def pa_expression_of_interest_params

    params.require(:pa_expression_of_interest).permit(:feasibility_or_options_work)

  end
    
end
