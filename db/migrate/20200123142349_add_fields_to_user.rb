class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :date_of_birth, :date)
    add_column(:users, :name, :string)
    add_column(:users, :line1, :string)
    add_column(:users, :line2, :string)
    add_column(:users, :line3, :string)
    add_column(:users, :townCity, :string)
    add_column(:users, :county, :string)
    add_column(:users, :postcode, :string)
    add_column(:users, :phone_number, :string)
  end
end
