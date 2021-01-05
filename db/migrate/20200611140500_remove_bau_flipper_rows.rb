class RemoveBauFlipperRows < ActiveRecord::Migration[6.0]
  def up
    execute "delete from flipper_gates where feature_key='bau';"
    execute "delete from flipper_features where key='bau';"
  end

  def down
    execute "insert into flipper_features (key, created_at, updated_at) values('bau', now(), now());"
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('bau', 'boolean', false, now(), now());"
  end
end
