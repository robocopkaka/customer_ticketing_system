class Customer < User
  has_many :support_requests, foreign_key: 'requester_id'
end