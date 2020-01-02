class CreateCashContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :cash_contributions, id: :uuid do |t|
      t.integer "amount"
      t.string "description"
      t.integer "secured"
      t.timestamps
    end
  end
end
