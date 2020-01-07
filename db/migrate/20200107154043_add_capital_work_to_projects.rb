class AddCapitalWorkToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :capital_work, :boolean
    add_column :projects, :capital_work_supporting_document, :string
  end
end
