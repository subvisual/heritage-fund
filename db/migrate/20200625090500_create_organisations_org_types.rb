class CreateOrganisationsOrgTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :organisations_org_types, id: :uuid do |t|
      t.references :organisation, type: :uuid, null: false, foreign_key: true
      t.references :org_type, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
