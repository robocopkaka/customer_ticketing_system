# frozen_string_literal: true

class SupportRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(agent_id)
    support_requests = SupportRequest
                         .where("resolved_at > ? AND assignee_id = ?",
                                Time.now - 1.month, agent_id)
    sps = support_requests.to_csv
    filename = generate_filename(agent_id)
    File.open(filename, "w")
    File.write(filename, sps)
    SupportRequestMailer
      .with(agent_id: agent_id, filename: filename)
      .export
      .deliver_now
  end

  private

  def generate_filename(agent_id)
    month = Time.now.month
    year = Time.now.year
    "public/requests/#{agent_id}-#{month}-#{year}-request"
  end
end
