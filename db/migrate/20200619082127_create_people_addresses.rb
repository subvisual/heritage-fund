class CreatePeopleAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :people_addresses, id: :uuid do |t|
      t.references  :address, type: :uuid, null: false, foreign_key: true 
      t.references  :person, type: :uuid, null: false, foreign_key: true 
    end
  end
end
