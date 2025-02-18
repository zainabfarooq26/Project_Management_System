class AddClientIdToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :client_id, :integer
  end
end
