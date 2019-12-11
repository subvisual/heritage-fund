class AddTypeToOrganisations < ActiveRecord::Migration[6.0]
  def up
    execute <<-DDL
      CREATE TYPE organisations_type AS ENUM (
        'registered_charity', 'local_authority', 'registered_company',
        'community_interest_company', 'faith_based_organisation', 'church_organisation',
        'community_group', 'voluntary_group', 'individual_private_owner_of_heritage',
        'other'
      );
    DDL
    add_column :organisations, :org_type, :organisations_type
  end

  def down
    remove_column :organisations, :org_type
    execute "DROP type organisations_type";
  end
end