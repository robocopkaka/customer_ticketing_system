class Customer < User
  has_many :support_requests, foreign_key: 'requester_id'
  has_many :comments, foreign_key: 'commenter_id'
end