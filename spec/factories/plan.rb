FactoryBot.define do
  factory :main_plan, class: Plan do |plan|
    title { "test plan title" }
    content { "test plan content" }
    association :user, factory: :main_user
  end
end
