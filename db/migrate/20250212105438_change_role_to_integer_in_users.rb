class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :role, :integer, using: 'role::integer'
  end
end
