class AddDeclarationsToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :declaration_reasons_description, :text
    add_column :projects, :user_research_declaration, :boolean, default: false
    add_column :projects, :keep_informed_declaration, :boolean, default: false
  end
end
