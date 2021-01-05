class AddTypeToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :org_type, :integer
  end
end
