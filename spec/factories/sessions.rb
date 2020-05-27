FactoryBot.define do
  factory :session do
    active { false }
    user_agent { "MyString" }
    expires_at { "2020-05-26 13:06:49" }
    deleted_at { "2020-05-26 13:06:49" }
  end
end
