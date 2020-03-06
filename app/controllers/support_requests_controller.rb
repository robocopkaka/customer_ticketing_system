class SupportRequestsController < ApplicationController
  before_action :authenticate_customer, only: %i[create]
  before_action :authenticate_resources, only: %i[index]
  before_action :find_support_request, only: %i[show]
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

  def show
    json_response(@support_request, "")
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
