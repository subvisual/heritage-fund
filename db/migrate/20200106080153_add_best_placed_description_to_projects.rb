class AddBestPlacedDescriptionToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :best_placed_description, :text
  end
end
