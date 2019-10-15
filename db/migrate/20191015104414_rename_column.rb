class RenameColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :organisations_id, :organisation_id
  end
end
