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

# 10種類のプランを作成
10.times do
  title = Faker::Lorem.sentence(1)
  content = Faker::Lorem.sentence(10)
  # 5人のユーザひとりひとりに作成
  for n in 1..5 do
    plan = User.find(n).plans.create!(title: title, content: content)

    # 作成したプランに対してアクティビティを10こ作成
    rand_method = ['walk','car','train','bus','taxi','air','ship','etc','tourism','meal','work','checkin','sleepin','wakeup','checkout','etc']
    10.times do |n|
      hour = n * 5
      plan.plan_details.create!(
        date: hour.hours.ago,
        place: Faker::Lorem.sentence(1),
        action_type: rand_method[rand(16)],
        action_memo: Faker::Lorem.sentence(10)
      )
    end

  end
end
