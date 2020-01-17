class Project::ProjectCheckAnswersController < ApplicationController

  include ProjectContext

  def save_continue
    redirect_to three_to_ten_k_project_confirm_declaration_get_path
  end

end
