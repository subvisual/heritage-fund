class AddNameToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :name, :string
  end
end
