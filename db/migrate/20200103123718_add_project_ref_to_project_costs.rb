class AddProjectRefToProjectCosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_costs, :project, type: :uuid, null: false, foreign_key: true
  end
end
