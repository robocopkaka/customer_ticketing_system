FactoryBot.define do
  factory :customer do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    password { "password" }
    password_confirmation { "password" }

    factory :customer_with_sessions do
      transient do
        sessions_count { 10 }
      end
      after(:create) do |user, evaluator|
        create_list(:session, evaluator.sessions_count, session_user: user)
      end
    end
  end
end