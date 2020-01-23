class Project::ProjectDeclarationController < ApplicationController
  include ProjectContext

  def update_confirm_declaration

    logger.debug "Updating declaration confirmation for project ID: #{@project.id}"

    @project.validate_confirm_declaration = true

    @project.update(confirm_declaration_params)

    if @project.valid?

      logger.debug "Finished updating declaration confirmation for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_application_submitted_get_path

    else

      logger.debug "Validation failed when updating declaration confirmation for " +
                       "project ID: #{@project.id}"

      render :show_confirm_declaration

    end


  end

  def update_declaration

    logger.debug "Updating declaration for project ID: #{@project.id}"

    @project.validate_is_partnership = true
    @project.validate_partnership_details = true if params[:project][:is_partnership] == "true"

    @project.update(declaration_params)

    if @project.valid?

      logger.debug "Finished updating declaration for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_confirm_declaration_get_path

    else

      logger.debug "Validation failed when updating declaration for project ID: #{@project.id}"

      render :show_declaration

    end

  end

  private

  def confirm_declaration_params

    if !params[:project].present?
      params.merge!({project: {confirm_declaration: ""}})
    end

    params.require(:project).permit(:confirm_declaration)

  end

  def declaration_params


    params.require(:project).permit(
        :declaration_reasons_description,
        :user_research_declaration,
        :keep_informed_declaration,
        :is_partnership,
        :partnership_details
    )

  end
end
