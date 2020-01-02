class AddLocationToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :line1, :string
    add_column :projects, :line2, :string
    add_column :projects, :line3, :string
    add_column :projects, :townCity, :string
    add_column :projects, :county, :string
    add_column :projects, :postcode, :string
  end
end
