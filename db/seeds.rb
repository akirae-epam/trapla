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

99.times do |user_number|
  name  = Faker::Name.name
  email = "example-#{user_number + 1}@railstutorial.org"
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
  (1..5).each do |plan_user_number|
    plan = User.find(plan_user_number).plans.create!(title: title,
                                                     content: content)

    # 作成したプランに対してアクティビティを10こ作成
    rand_method = %w[walk car train bus taxi airplane ship move_etc
                     tourism meal work checkin sleepin wakeup checkout visit_etc]
    10.times do |plan_detail_no|
      hour = plan_detail_no * 5
      plan.plan_details.create!(
        date: hour.hours.ago,
        place: "Place #{plan_detail_no}",
        action_type: rand_method[rand(16)],
        action_memo: Faker::Lorem.sentence(10),
        belongings: "もちもの１\nもちもの２\nもちもの３\nもちもの４",
        payments_items: "費用1#{plan_detail_no},費用2#{plan_detail_no},費用3#{plan_detail_no},費用4#{plan_detail_no}",
        payments_moneys: '100,2000,30000,400000'
      )
    end
  end
end
