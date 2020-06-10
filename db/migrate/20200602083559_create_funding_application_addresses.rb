class CreateFundingApplicationAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :funding_application_addresses, id: :uuid do |t|
      t.references :address, type: :uuid, null: false, foreign_key: true
      t.references :funding_application, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
