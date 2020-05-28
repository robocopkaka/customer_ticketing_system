class Session < ApplicationRecord
  self.primary_key = "uid"
  include GenerateUid

  # associations
  belongs_to :session_user, polymorphic: true

  #scopes
  scope :active, -> { where(active: true) }


  before_create :set_uid

  def session_user_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end

  private

  def set_uid
    self.uid = generate_uid(self.class.to_s)
  end
end
