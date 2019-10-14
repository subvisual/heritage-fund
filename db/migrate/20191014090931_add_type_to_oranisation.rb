class AddTypeToOranisation < ActiveRecord::Migration[6.0]
  def up
    add_column :organisations, :type, :organisation_type
  end
  def down
    remove_column :organisations, :type, :organisation_type
  end
end
