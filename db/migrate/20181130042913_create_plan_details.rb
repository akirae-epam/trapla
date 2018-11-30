class CreatePlanDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_details do |t|
      t.datetime :date
      t.string :place
      t.string :action_type
      t.string :action
      t.text :action_memo
      t.references :plan, foreign_key: true

      t.timestamps
    end
       add_index :plan_details, [:plan_id, :created_at]
  end
end
