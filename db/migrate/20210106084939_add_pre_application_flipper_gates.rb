class AddPreApplicationFlipperGates < ActiveRecord::Migration[6.0]
  def up
    execute "insert into flipper_gates (id, feature_key, key, value, created_at, updated_at) Values((select max(id) from flipper_gates) + 1,'project_enquiries_enabled', 'boolean', false, now(), now());"
    execute "insert into flipper_gates (id, feature_key, key, value, created_at, updated_at) Values((select max(id) from flipper_gates) + 1,'expressions_of_interest_enabled', 'boolean', false, now(), now());"
  end

  def down
    execute "delete from flipper_gates where feature_key = 'project_enquiries_enabled';"
    execute "delete from flipper_gates where feature_key = 'expressions_of_interest_enabled';"
  end
end