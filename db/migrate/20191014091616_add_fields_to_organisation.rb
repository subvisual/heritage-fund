class AddFieldsToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :line1, :string
    add_column :organisations, :townCity, :string
    add_column :organisations, :county, :string
    add_column :organisations, :postcode, :string
    add_column :organisations, :company_number, :integer
    add_column :organisations, :charity_number, :integer
    add_column :organisations, :charity_number_ni, :integer
  end
end
