namespace :data_migrations do
  desc "TODO"
  task add_priority_to_support_requests: :environment do
    requests = SupportRequest.where(priority: nil)

    requests.each do |req|
      req.update!(priority: "normal")
    end
  end
end
