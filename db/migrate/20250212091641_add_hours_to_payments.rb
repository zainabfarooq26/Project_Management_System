class AddHoursToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :hours, :integer
  end
end
