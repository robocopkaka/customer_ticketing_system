class AdminsController < ApplicationController
  before_action :authenticate_admin, only: %i[assign]
  before_action :find_support_request, only: %i[assign]
  before_action :verify_support_agent, only: %i[assign]

  def assign
    support_request = SupportRequestService
                        .new(
                          request_params: params,
                          support_request: @support_request
                        ).assign_request
    json_response(support_request, "Request assigned successfully")
  end

  private

  def find_support_request
    @support_request = SupportRequest.find_by!(uid: params[:id])
  end

  # Prevents a request from being assigned to a customer.
  # Result doesn't need to be returned. Only the exception matters
  def verify_support_agent
    SupportAgent.find_by!(uid: params[:assignee_id])
  end
end
