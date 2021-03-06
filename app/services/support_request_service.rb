class SupportRequestService
  def initialize(params={})
    @customer = params[:customer]
    @request_params = params[:request_params]
    @support_request = params[:support_request]
  end

  def create
    support_request = @customer.support_requests.create!(@request_params)
    support_request.tap do |req|
      AssignRequestsWorker.perform_async(req.id)
      CustomerMailer
        .with(customer_id: @customer.id, support_request_id: req.id)
        .open_request.deliver_later
    end
  end

  def assign_request(request_id:, assignee_id:)
    support_request = SupportRequest.find_by!(uid: request_id)
    support_request
      .update(assignee_id: assignee_id, status: "assigned")

    AdminMailer
      .with(
        assignee_id: assignee_id,
        support_request_id: request_id
      ).assign_request.deliver_later
    support_request
  end

  def self.fetch_requests(resource, query = "")
    unless query.blank?
      return resource.support_requests
                           .where("status = ?", query)

    end
    resource.support_requests
  end

  # call fetch requests first and then group
  def self.group_by_priority(resource)
    fetch_requests(resource).group_by(&:priority)
  end
end