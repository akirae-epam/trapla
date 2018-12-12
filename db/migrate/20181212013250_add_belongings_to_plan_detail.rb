class AddBelongingsToPlanDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :plan_details, :belongings, :text
  end
end
