class AddStatusToPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :payments, :status, :string
  end
end
