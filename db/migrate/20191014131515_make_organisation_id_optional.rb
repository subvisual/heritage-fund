class MakeOrganisationIdOptional < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :organisations_id, :uuid, :null => true
  end
end
