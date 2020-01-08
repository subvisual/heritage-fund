class AddCapitalWorkToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :capital_work, :boolean
  end
end
