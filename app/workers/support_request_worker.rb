# frozen_string_literal: true

class SupportRequestWorker
  include Sidekiq::Worker

  def perform(agent_id)
    support_requests = SupportRequest.where("resolved_at > ?", Time.now - 1.month)
    sps = support_requests.to_csv
    filename = generate_filename(agent_id)
    File.open(filename, "w")
    File.write(filename, sps.to_csv)
  end

  private

  def generate_filename(agent_id)
    month = Time.now.month
    year = Time.now.year
    "public/#{agent_id}-#{month}-#{year}-request"
  end
end
