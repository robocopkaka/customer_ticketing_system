FactoryBot.define do
  factory :session do
    for_customer

    user_agent { Faker::Internet.user_agent }
    # expires_at { Time.current + 24.hours }
    # deleted_at { nil }

    trait :for_admin do
      association :session_user, factory: :admin
    end

    trait :for_customer do
      association :session_user, factory: :customer
    end

    trait :for_support_agent do
      association :session_user, factory: :support_agent
    end
  end
end
