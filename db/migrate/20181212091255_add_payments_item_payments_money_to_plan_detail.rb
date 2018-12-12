class AddPaymentsItemPaymentsMoneyToPlanDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :plan_details, :payments_money, :text
    add_column :plan_details, :payments_item, :text
  end
end
