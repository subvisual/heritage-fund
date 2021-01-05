class CreateOrgIncomeTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :org_income_types, id: :uuid do |t|
      t.string :name
      t.timestamps
    end
  end
end
