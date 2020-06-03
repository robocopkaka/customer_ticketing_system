class User < ApplicationRecord
  include GenerateUid
  self.primary_key = 'uid'
  REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password
  validates_presence_of :name, :email
  validates :email,
            format: { with: REGEX },
            uniqueness: { case_sensitive: false }

  # can't use Session here since there are Rails specific modules
  # named Session
  concerning :SessionModel do
    included do
      has_many :sessions, as: :session_user
    end
    # association methods
    def all_sessions
      sessions.order(created_at: :asc)
    end

    def active_sessions
      all_sessions.active
    end
  end
end
