class AddMatterToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :matter, :text
  end
end
