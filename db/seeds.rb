# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "ffaker"
require "a_r/order"
require "a_r/user"

user1 = AR::User.create!(email: FFaker::Internet.email)
user2 = AR::User.create!(email: FFaker::Internet.email)

20.times do
  AR::Order.create!(
    user_name: FFaker::Internet.user_name,
    phone_number: FFaker::PhoneNumber.short_phone_number,
    product_name: FFaker::Product.product_name,
    cost: rand(1000..20000),
    user: [user1, user2].sample
  )
end
