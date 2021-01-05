class CreatePlansForLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans_for_loans, id: :uuid do |t|
      t.string :plan

      t.timestamps
    end
  end
end
