class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :item
      t.integer :money
      t.references :plan_detail, foreign_key: true

      t.timestamps
    end
  end
end
