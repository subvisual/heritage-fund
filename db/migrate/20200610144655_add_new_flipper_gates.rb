class AddNewFlipperGates < ActiveRecord::Migration[6.0]
  def up
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('covid_banner_enabled', 'boolean', false, now(), now());"
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('grant_programme_hef_loan', 'boolean', false, now(), now());"
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('registration_enabled', 'boolean', false, now(), now());"
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('new_applications_enabled', 'boolean', false, now(), now());"
    execute "insert into flipper_gates (feature_key, key, value, created_at, updated_at) Values('grant_programme_sff_small', 'boolean', false, now(), now());"
  end

  def down
    execute "delete from flipper_gates where feature_key = 'covid_banner_enabled';"
    execute "delete from flipper_gates where feature_key = 'grant_programme_hef_loan';"
    execute "delete from flipper_gates where feature_key = 'registration_enabled';"
    execute "delete from flipper_gates where feature_key = 'new_applications_enabled';"
    execute "delete from flipper_gates where feature_key = 'grant_programme_sff_small';"
  end
end
