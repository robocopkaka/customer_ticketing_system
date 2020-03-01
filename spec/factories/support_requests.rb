FactoryBot.define do
  factory :support_request do
    subject { Faker::Name.first_name }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    resolved_at { nil }
    requester_id { create(:customer).id }
    assignee_id { nil }
  end
end
