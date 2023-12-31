# coding: utf-8

User.create!(name: "上長A",
             email: "zyoutyouA@email.com",
             password: "123456",
             password_confirmation: "123456",
             admin: true,
             superior: true)
             
User.create!(name: "上長B",
             email: "zyoutyouB@email.com",
             password: "123456",
             password_confirmation: "123456",
             admin: true,
             superior: true)

10.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
