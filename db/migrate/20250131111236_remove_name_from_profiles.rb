class RemoveNameFromProfiles < ActiveRecord::Migration[7.2]
  def change
    remove_column :profiles, :name, :string
  end
end
