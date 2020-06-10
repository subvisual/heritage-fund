class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :line1
      t.string :line2
      t.string :line3
      t.string :town_city
      t.string :county
      t.string :postcode
      t.string :udprn
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
