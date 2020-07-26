User.create!(name:  "Example User",
            username: "example",
            email: "example@railstutorial.org",
            password:              "foobar",
            password_confirmation: "foobar")

  49.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!( name:  name,
                  email: email,
                  username:name,
                  password:password,
                  password_confirmation: password)
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
