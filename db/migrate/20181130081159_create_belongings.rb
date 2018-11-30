class CreateBelongings < ActiveRecord::Migration[5.2]
  def change
    create_table :belongings do |t|
      t.string :stuff
      t.integer :number
      t.references :plan_detail, foreign_key: true

      t.timestamps
    end
  end
end
