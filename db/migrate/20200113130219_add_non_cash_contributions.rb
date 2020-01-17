class AddNonCashContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :non_cash_contributions, id: :uuid do |t|
      t.integer "amount"
      t.string "description"
      t.timestamps
    end
  end
end
