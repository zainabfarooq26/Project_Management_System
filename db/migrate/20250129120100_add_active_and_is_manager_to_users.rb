class AddActiveAndIsManagerToUsers < ActiveRecord::Migration[7.2]
  def change
    # Adding active column only if it doesn't already exist
    add_column :users, :active, :boolean, default: true unless column_exists?(:users, :active)
    
    # Adding is_manager column only if it doesn't already exist
    add_column :users, :is_manager, :boolean, default: false unless column_exists?(:users, :is_manager)
  end
end
