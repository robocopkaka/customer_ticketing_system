FactoryBot.define do
  factory :customer do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    password { "password" }
    password_confirmation { "password" }
  end
end