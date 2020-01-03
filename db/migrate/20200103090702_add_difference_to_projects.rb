class AddDifferenceToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :difference, :text
  end
end
