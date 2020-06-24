class CreateUsersAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :users_addresses, id: :uuid do |t|
      t.references  :address, type: :uuid, null: false, foreign_key: true 
      t.references  :user, type: :bigint, null: false, foreign_key: true 
    end
  end
end
