class AddMissingTimestampColumns < ActiveRecord::Migration[6.0]
  def change
    change_table :people  do |t|
      t.timestamps
    end
    change_table :people_addresses do |t|
      t.timestamps
    end
  end
end
