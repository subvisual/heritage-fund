class AddAddressFieldsToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :line2, :string
    add_column :organisations, :line3, :string
  end
end
