class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.date :paid_on
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
