class AddForeignKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :person, type: :uuid, null: true, foreign_key: true
  end
end
