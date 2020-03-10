# seeds

10.times do
  Customer.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "customer-#{Faker::Name.first_name}-#{Customer.count + 1}@gmail.com",
    password: "password",
    "password_confirmation": "password"
  )

  SupportAgent.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "support-#{Faker::Name.first_name}-#{SupportAgent.count + 1}@gmail.com",
    password: "password",
    "password_confirmation": "password"
  )

  Admin.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "admin-#{Faker::Name.first_name}-#{Admin.count + 1}@gmail.com",
    password: "password",
    "password_confirmation": "password"
  )
end

customers = Customer.first(5).pluck(:id)

20.times do
  SupportRequest.create!(
    subject: Faker::Lorem.word,
    description: Faker::Lorem.paragraph(sentence_count: 1),
    requester_id: customers.sample
  )
end

support_agents = SupportAgent.first(3).pluck(:id)
support_requests = SupportRequest.first(3).pluck(:id)

30.times do
  Comment.create!(
    body: Faker::Lorem.paragraph(sentence_count: 2),
    commenter_id: support_agents.sample,
    support_request_id: support_requests.sample
  )
end
