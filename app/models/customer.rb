class Customer < User
  has_many :support_requests, foreign_key: 'requester_id'
  has_many :comments, foreign_key: 'commenter_id'

  before_save :set_uid

  private

  def set_uid
    self.uid = generate_uid(self.type)
  end
end