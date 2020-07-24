class AddRepaymentFrequencies < ActiveRecord::Migration[6.0]
  def up
    execute "insert into repayment_frequencies (frequency, created_at, updated_at) values ('Monthly', now(), now());"
    execute "insert into repayment_frequencies (frequency, created_at, updated_at) values ('Quarterly', now(), now());"
    execute "insert into repayment_frequencies (frequency, created_at, updated_at) values ('Yearly', now(), now());"
  end

  def down
    execute "delete from repayment_frequencies where frequency = 'Monthly';"
    execute "delete from repayment_frequencies where frequency = 'Quarterly';"
    execute "delete from repayment_frequencies where frequency = 'Yearly';"
  end
end
