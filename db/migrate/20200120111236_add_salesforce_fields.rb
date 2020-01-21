class AddSalesforceFields < ActiveRecord::Migration[6.0]
  def change
    add_column(:projects, :salesforce_case_number, :string)
    add_column(:projects, :salesforce_case_id, :string)
    add_column(:projects, :project_reference_number, :string)
    add_column(:projects, :submitted_on, :datetime)
    add_column(:organisations, :salesforce_account_id, :string)
  end
end
