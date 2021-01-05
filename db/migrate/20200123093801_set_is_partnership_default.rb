class SetIsPartnershipDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:projects, :is_partnership, from: nil, to: false)
  end
end
