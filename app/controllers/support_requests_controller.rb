class SupportRequestsController < ApplicationController
  skip_after_action :refresh_session, only: %i[group_by_priority export_as_csv show]
  before_action :authenticate_customer, only: %i[create]
  before_action :authenticate_resources, only: %i[index]
  before_action :find_support_request, only: %i[show resolve]
  before_action :authenticate_support_agent, only: %i[resolve export_as_csv]
  def create
    support_request = SupportRequestService
                        .new(
                          customer: current_customer,
                          request_params: support_request_params
                          ).create
    json_response(support_request, "Request created successfully", :created)
  end

  def index
    support_requests = SupportRequestService.fetch_requests(authenticate_resources, params[:query])
    json_response(
      support_requests, {
      open: authenticate_resources.open_requests_count,
      closed: authenticate_resources.resolved_requests_count
    })
  end

  def group_by_priority
    requests = SupportRequestService.group_by_priority(authenticate_resources)
    json_response(requests, "")
  end

  def show
    json_response(@support_request, "")
  end

  # consider if support agents can resolve tickets not assigned to
  # them
  def resolve
    @support_request.update(status: 'resolved', resolved_at: Time.now)
    json_response(@support_request, "")
  end

  def export_as_csv
    ExportRequestsWorker.perform_async(current_support_agent.id)
    json_response({}, "Generated requests have been sent to your mail")
  end

  private

  def support_request_params
    params.permit(
      :subject,
      :description
    )
  end

  def find_support_request
    @support_request = SupportRequest.find_by!(uid: params[:id])
  end

  # run authentications for both customers and support_agents
  def authenticate_resources
    authenticate_for(SupportAgent) || authenticate_for(Customer) || authenticate_for(Admin)
  end
end
