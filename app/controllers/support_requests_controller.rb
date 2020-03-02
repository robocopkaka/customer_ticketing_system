class SupportRequestsController < ApplicationController
  before_action :authenticate_customer, only: %i[create]
  before_action :find_support_request, only: %i[show]
  def create
    support_request = SupportRequestService
                        .new(
                          customer: current_customer,
                          request_params: support_request_params
                          ).create
    json_response(support_request, "Request created successfully", :created)
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
end
