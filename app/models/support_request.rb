class SupportRequest < ApplicationRecord
  self.primary_key = 'uid'
  delegate :customer, :support_agent, to: :users

  belongs_to :customer,
             class_name: 'User',
             foreign_key: 'requester_id',
             optional: true,
             primary_key: 'uid'
  belongs_to :support_agent,
             class_name: 'User',
             foreign_key: 'assignee_id',
             optional: true

  has_many :comments, primary_key: 'uid'

  default_scope { order(created_at: :asc) }

  scope :open, -> { where(status: 'opened') }

  validates_presence_of :subject, :description

  enum status: {
    opened: "opened",
    assigned: "assigned",
    resolved: "resolved"
  }

  before_create :set_uid

  private
  def set_uid
    self.uid = "request-#{SecureRandom.hex}"
  end
end
