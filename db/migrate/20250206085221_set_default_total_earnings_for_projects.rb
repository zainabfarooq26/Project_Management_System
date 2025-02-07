class SetDefaultTotalEarningsForProjects < ActiveRecord::Migration[7.2]
  def change
    change_column_default :projects, :total_earnings, 0
  end
end
