# frozen_string_literal: true

class ExportRequestsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(agent_id)
    support_requests = SupportRequest
                         .where("resolved_at > ? AND assignee_id = ?",
                                Time.now - 1.month, agent_id)
    sps = support_requests.to_csv

    FileUtils.mkdir_p "public/requests" unless Dir.exist?("public/requests")

    filename = File.join("public", "requests",generate_filename(agent_id))
    File.open(filename, "w") { |f| f.write sps }
    SupportRequestMailer
      .with(agent_id: agent_id, filename: filename)
      .export
      .deliver_now
  end

  private

  def generate_filename(agent_id)
    month = Time.now.month
    year = Time.now.year
    "#{agent_id}-#{month}-#{year}-request.csv"
  end
end
