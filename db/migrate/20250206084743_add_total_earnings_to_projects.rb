class AddTotalEarningsToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :total_earnings, :decimal
  end
end
