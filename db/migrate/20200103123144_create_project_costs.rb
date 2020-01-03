class CreateProjectCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :project_costs, id: :uuid do |t|
      t.integer :type
      t.integer :amount
      t.text :description
      t.timestamps
    end
  end
end
