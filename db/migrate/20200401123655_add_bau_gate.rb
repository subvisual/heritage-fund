class AddBauGate < ActiveRecord::Migration[6.0]
  def up
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('bau', 'boolean', false, NOW(), NOW());"
  end

  def down
    execute "delete from flipper_gates where feature_key = 'bau';"
  end
end
