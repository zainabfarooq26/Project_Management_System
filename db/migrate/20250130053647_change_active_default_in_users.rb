class ChangeActiveDefaultInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :active, from: nil, to: true
    change_column_null :users, :active, false
  end
end
