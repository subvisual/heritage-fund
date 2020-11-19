class RemoveOrganisationFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :organisation_id, :uuid
  end
end
