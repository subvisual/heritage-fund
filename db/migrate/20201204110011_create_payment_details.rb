class CreatePaymentDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_details, id: :uuid do |t|
      t.text :account_name
      t.text :account_number
      t.text :sort_code

      t.references :funding_application, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
