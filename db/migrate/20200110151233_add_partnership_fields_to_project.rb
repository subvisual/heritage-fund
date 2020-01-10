class AddPartnershipFieldsToProject < ActiveRecord::Migration[6.0]
  def change
    add_column(:projects, :is_partnership, :boolean)
    add_column(:projects, :partnership_details, :text)
  end
end
