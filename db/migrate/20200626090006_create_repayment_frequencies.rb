class CreateRepaymentFrequencies < ActiveRecord::Migration[6.0]
  def change
    create_table :repayment_frequencies, id: :uuid do |t|
      t.string :frequency

      t.timestamps
    end
  end
end
