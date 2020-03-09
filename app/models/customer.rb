class Customer < User
  has_many :support_requests, foreign_key: 'requester_id'
  has_many :comments, foreign_key: 'commenter_id'

  before_create :set_uid

  # using counter cache might not work here since I want more granularity
  def open_requests_count
    support_requests.where("status = ? OR status = ?", 'opened', 'assigned').count
  end

  def resolved_requests_count
    support_requests.where(status: 'resolved').count
  end

  private

  def set_uid
    self.uid = generate_uid(self.type)
  end
end