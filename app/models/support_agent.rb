class SupportAgent < User
  has_many :support_requests, foreign_key: 'assignee_id'
end