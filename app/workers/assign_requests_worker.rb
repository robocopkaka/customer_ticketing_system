# frozen_string_literal: true

# worker for assigning requests
class AssignRequestsWorker
  include Sidekiq::Worker
  sidekiq_options(retry: 1)

  def perform(request_id:)
    agents = available_agents
    open_request_notifier if agents.empty?
    SupportRequestService
      .new
      .assign_request(request_id: request_id, assignee_id: agents.first.id)
  end

  private

  def available_agents
    SupportAgent
      .where("support_requests_count < ?", 5)
      .order(support_requests_count: :asc)
  end

  # if there's no agent to handle a request. Send a mail to admin with it

  def open_request_notifier
    p "Yay for now"
  end
end