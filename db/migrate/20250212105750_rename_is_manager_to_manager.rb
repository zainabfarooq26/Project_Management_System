class RenameIsManagerToManager < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :is_manager, :manager
  end
end
