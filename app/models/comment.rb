class Comment < ApplicationRecord
  self.primary_key = 'uid'
  belongs_to :support_request, primary_key: 'uid'
  belongs_to :customer,
             class_name: 'User',
             foreign_key: 'commenter_id',
             optional: true,
             primary_key: 'uid'
  belongs_to :support_agent,
             class_name: "User",
             foreign_key: "commenter_id",
             optional: true,
             primary_key: 'uid'

  default_scope do
    includes(support_request: [:customer, :support_agent])
      .order(created_at: :desc)
  end

  scope :order_asc, -> { order('created_at asc') }

  validates_presence_of :body

  before_create :set_uid

  private

  def set_uid
    token = "comm-#{SecureRandom.hex}"
    token_exists = Comment.find_by(uid: token)

    while token_exists
      token = "comm-#{SecureRandom.hex}"
      token_exists = Comment.find_by(uid: token)
    end
    self.uid = token
  end
end
