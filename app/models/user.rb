class User < ApplicationRecord
  include GenerateUid
  self.primary_key = 'uid'
  REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password
  validates_presence_of :name, :email
  validates :email,
            format: { with: REGEX },
            uniqueness: { case_sensitive: false }
end
