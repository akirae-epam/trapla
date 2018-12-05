# frozen_string_literal: true

class AddIndexPlanDetails < ActiveRecord::Migration[5.2]
  def change; end
  add_index :plan_details, %i[plan_id created_at date]
end
