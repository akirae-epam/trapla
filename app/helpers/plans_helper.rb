# frozen_string_literal: true

module PlansHelper
  include PlanDetailsHelper

  def plan_belongings_payments(plan)
    total_belongings = []
    total_payments = 0
    # 持ち物をマージ
    plan.plan_details.each do |plan_detail|
      next if plan_detail.belongings.nil?

      total_belongings.push(plan_detail.belongings.split(/\n/)).flatten!
    end
    # 費用の合計を算出
    plan.plan_details.each do |plan_detail|
      next if plan_detail.payments_moneys.nil?

      moneys = plan_detail.payments_moneys.split(',')
      moneys.each { |money| total_payments += money.to_i }
    end
    @plan_belongings = total_belongings.uniq # 持ち物の重複は削除して返す
    @plan_payments = total_payments
  end
end
