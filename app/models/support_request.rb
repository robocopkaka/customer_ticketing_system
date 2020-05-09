require 'csv'
class SupportRequest < ApplicationRecord
  include GenerateUid
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

  enum priority: {
    low: "low",
    normal: "normal",
    high: "high"
  }

  before_create :set_uid

  def self.to_csv
    CSV.generate  do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

  private

  def set_uid
    self.uid = generate_uid(self.class.to_s)
  end
end
