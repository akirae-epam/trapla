User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar"
            )

99.times do |n|
  name = "User name " + n.to_s
  email = "example-#{n+1}@railstutorial.org"
  User.create!(name: name,
               email: email,
               password: "foobar",
               password_confirmation: "foobar")
end
