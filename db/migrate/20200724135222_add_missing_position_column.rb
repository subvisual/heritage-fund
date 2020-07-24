class AddMissingPositionColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :position, :string
  end
end
