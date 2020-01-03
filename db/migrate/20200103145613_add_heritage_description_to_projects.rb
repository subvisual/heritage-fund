class AddHeritageDescriptionToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :heritage_description, :text
  end
end
