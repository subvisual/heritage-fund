class MakeOrganisationIdOptional < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
    CREATE TYPE form_type AS ENUM ('local-authority', 'other-public-sector-organisation', 'registered-charity', 'faith-based-or-church-organisation', 'private-owner-of-heritage' );
    SQL
    change_column :users, :organisations_id, :uuid\, :null => true
  end
end
