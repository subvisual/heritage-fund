class CreateOrganisations < ActiveRecord::Migration[6.0]
  def up
    create_table :organisations, id: :uuid do |t|
      execute <<-SQL
      CREATE TYPE organisation_type AS ENUM ('local-authority', 'other-public-sector-organisation', 'registered-charity', 'faith-based-or-church-organisation', 'private-owner-of-heritage' );
    SQL
    # add_column t, :type, :organisation_type
    # add_column t, :string, :organisation_type_other
    # add_column t, :string, :line1
    # add_column t, :string, :townCity
    # add_column t, :string, :county
    # add_column t, :string, :postcode
    # add_column t, :integer, :company_number
    # add_column t, :integer, :charity_number
    # add_column t, :integer, :charity_number_ni
      t.timestamps
    end
    
  end
end
