class AddPlansForLoans < ActiveRecord::Migration[6.0]
  def up
    execute "insert into plans_for_loans (plan, created_at, updated_at) values ('Cashflow', now(), now());"
    execute "insert into plans_for_loans (plan, created_at, updated_at) values ('Staff salaries', now(), now());"
    execute "insert into plans_for_loans (plan, created_at, updated_at) values ('Working capital', now(), now());"
    execute "insert into plans_for_loans (plan, created_at, updated_at) values ('Recovering planning', now(), now());"
  end

  def down
    execute "delete from plans_for_loans where plan = 'Cashflow';"
    execute "delete from plans_for_loans where plan = 'Staff salaries';"
    execute "delete from plans_for_loans where plan = 'Working capital';"
    execute "delete from plans_for_loans where plan = 'Recovering planning';"
  end
end
