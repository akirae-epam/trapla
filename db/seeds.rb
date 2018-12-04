# frozen_string_literal: true

User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: 'Test User',
             email: 'test@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(1)
  content = Faker::Lorem.sentence(10)
  users.each { |user| user.plans.create!(title: title, content: content) }
end

plans = Plan.order(:created_at).take(5)
plans.each do |plan|
  10.times do |_n|
    pid = plan.id
    plan.plan_details.create!(
      date: pid.hours.ago,
      place: Faker::Lorem.sentence(1),
      action_type: 'car',
      action_memo: Faker::Lorem.sentence(10)
    )
  end
end
