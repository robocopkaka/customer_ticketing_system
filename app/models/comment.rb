class Comment < ApplicationRecord
  belongs_to :support_request
  belongs_to :customer,
             class_name: 'User',
             foreign_key: 'commenter_id',
             optional: true
  belongs_to :support_agent,
             class_name: "User",
             foreign_key: "commenter_id",
             optional: true

  default_scope { includes(support_request: [:customer, :support_agent]) }

  scope :order_desc, -> { order('created_at asc') }

  validates_presence_of :body
end
