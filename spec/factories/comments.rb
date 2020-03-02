FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commenter_id { 1 }
    support_request { nil }
  end
end
