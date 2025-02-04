class CreateTimeLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :time_logs do |t|
      t.integer :hours
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
