class RenamePaymentItemToPlanDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :plan_details, :payments_item, :payments_items
    rename_column :plan_details, :payments_money, :payments_moneys
  end
end
