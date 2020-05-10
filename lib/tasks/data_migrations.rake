namespace :data_migrations do
  desc "TODO"
  task add_priority_to_support_requests: :environment do
    requests = SupportRequest.where(priority: nil)

    requests.each do |req|
      req.update!(priority: "normal")
    end
  end

  task update_open_requests_count: :environment do
    agents = SupportAgent.includes(:support_requests)

    agents.each do |agent|
      agent.update!(
        support_requests_count: agent.support_requests.assigned.count
      )
    end
  end
end
