class User < ApplicationRecord
  self.primary_key = 'uid'
  REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password
  validates_presence_of :name, :email
  validates :email,
            format: { with: REGEX },
            uniqueness: { case_sensitive: false }

  def generate_uid(type)
    "#{type.downcase[0..3]}-#{SecureRandom.hex}"
  end
end
