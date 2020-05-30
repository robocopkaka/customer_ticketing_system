class Session < ApplicationRecord
  self.primary_key = "uid"
  include GenerateUid

  # associations
  belongs_to :session_user, polymorphic: true

  #scopes
  scope :active, -> { where("expires_at > ? AND deleted_at IS ?", Time.current, nil) }


  before_create :set_uid, :set_expires_at

  def session_user_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end

  private

  def set_uid
    self.uid = generate_uid(self.class.to_s)
  end

  def set_expires_at
    self.expires_at = Time.current + 24.hours
  end
end
