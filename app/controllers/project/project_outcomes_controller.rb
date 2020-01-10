class Project::ProjectOutcomesController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating other outcomes for project ID: #{@project.id}"

    remove_outcome_descriptions

    @project.validate_other_outcomes = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished updating other outcomes for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_project_costs_path

    else

      logger.debug "Validation failed when updating other outcomes for project ID: #{@project.id}"

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
      for i in 2..9
        if params[:project]["outcome_#{i}"] == "false"
          params[:project]["outcome_#{i}_description"] = ""
        end
      end
    end
  end

end
