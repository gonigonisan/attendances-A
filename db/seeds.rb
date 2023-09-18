# coding: utf-8

User.create!(name: "爆豪勝己",
             email: "bakugou@email.com",
             password: "123456",
             password_confirmation: "123456",
             admin: true)

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end