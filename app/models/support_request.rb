class SupportRequest < ApplicationRecord
  delegate :customer, :support_agent, to: :users

  belongs_to :customer,
             class_name: 'User',
             foreign_key: 'requester_id',
             optional: true
  belongs_to :support_agent,
             class_name: 'User',
             foreign_key: 'assignee_id',
             optional: true

  validates_presence_of :subject, :description

  enum status: {
    opened: "opened",
    assigned: "assigned",
    resolved: "resolved"
  }
end
