class ChangeCharityNumberColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :organisations, :charity_number, :string
  end
end
