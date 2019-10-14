class AddUserToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :organisations, type: :uuid, null: false, foreign_key: true
  end
end
