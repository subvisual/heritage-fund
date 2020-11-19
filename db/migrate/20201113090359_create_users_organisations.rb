class CreateUsersOrganisations < ActiveRecord::Migration[6.0]
  def change
    create_table :users_organisations, id: :uuid do |t|
      t.references :user, type: :int, null: false, foreign_key: true
      t.references :organisation, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
