class ChangeCompanyNumberFieldToString < ActiveRecord::Migration[6.0]
  def change
    change_column :organisations, :company_number, :string
  end
end
