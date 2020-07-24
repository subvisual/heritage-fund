class AddOrgIncomeTypes < ActiveRecord::Migration[6.0]
  def up
    execute "insert into org_income_types (name, created_at, updated_at) values ('Government contract', now(), now());"
    execute "insert into org_income_types (name, created_at, updated_at) values ('Rental Income', now(), now());"
    execute "insert into org_income_types (name, created_at, updated_at) values ('Membership fees', now(), now());"
    execute "insert into org_income_types (name, created_at, updated_at) values ('Grants', now(), now());"
    execute "insert into org_income_types (name, created_at, updated_at) values ('Donations', now(), now());"
    execute "insert into org_income_types (name, created_at, updated_at) values ('Trading', now(), now());"
  end

  def down
    execute "delete from org_income_types where name = 'Government contract';"
    execute "delete from org_income_types where name = 'Rental Income';"
    execute "delete from org_income_types where name = 'Membership fees';"
    execute "delete from org_income_types where name = 'Grants';"
    execute "delete from org_income_types where name = 'Donations';"
    execute "delete from org_income_types where name = 'Trading';"
  end
end
