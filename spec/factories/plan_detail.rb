# frozen_string_literal: true

FactoryBot.define do
  factory :main_plan_detail, class: PlanDetail do |_plan_detail|
    date { '2018/01/01 12:00' }
    place { 'place test1' }
    action_type { 'walk' }
    action_memo { 'action memo test1' }
    belongings { "Plan Detail Belonging Test1\nPlan Detail Belonging Test2" }
    payments_items { 'payment1,payment2,payment3' }
    payments_moneys { '1000,2000,3000' }
    association :plan, factory: :main_plan
  end
end
