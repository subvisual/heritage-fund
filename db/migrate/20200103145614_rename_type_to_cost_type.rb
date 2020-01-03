class RenameTypeToCostType < ActiveRecord::Migration[6.0]
  def change
    rename_column(:project_costs, :type, :cost_type)
  end
end
