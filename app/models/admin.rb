class Admin < User
  before_save :set_uid

  # can't set up a relation to SupportRequest for admins but
  # admins should be able to see all requests
  def support_requests
    SupportRequest.all
  end

  def open_requests_count
    support_requests.where("status = ? OR status = ?", 'opened', 'assigned').count
  end

  def resolved_requests_count
    support_requests.where(status: 'resolved').count
  end

  private

  def set_uid
    self.uid = generate_uid(self.class.to_s)
  end
end