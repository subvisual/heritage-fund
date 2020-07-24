class AddCustomOrgTypeToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column(:organisations, :custom_org_type, :string)
  end
end
