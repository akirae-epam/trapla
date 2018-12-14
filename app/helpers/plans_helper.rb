# frozen_string_literal: true

module PlansHelper
  include PlanDetailsHelper

  def merge_belongings(plan)
    total_belongings = []
    plan.plan_details.each do |plan_detail|
      total_belongings.push(plan_detail.belongings.split(/\n/)).flatten!
    end
    @plan_belongings = total_belongings.uniq
  end

  def merge_payments(plan)
    total_payments = []
    plan.plan_details.each_with_index do |plan_detail, i|
      items = plan_detail.payments_items.split(',')
      moneys = plan_detail.payments_moneys.split(',')
      items.each_with_index do |item, n|
        each_payment = {}
        each_payment[:id] = i * items.length + n
        each_payment[:item] = item
        each_payment[:money] = moneys[n]
        each_payment[:plan_detail_id] = plan_detail.id
        each_payment[:date] = plan_detail.date
        total_payments.push(each_payment)
      end
    end
    @plan_payments = total_payments
  end
end
