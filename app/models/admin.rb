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
    token = "admi-#{SecureRandom.hex}"
    token_exists = Admin.find_by(uid: token)

    while token_exists
      token = "admi-#{SecureRandom.hex}"
      token_exists = Admin.find_by(uid: token)
    end
    self.uid = token
  end
end