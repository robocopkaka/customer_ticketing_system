class Admin < User
  before_save :set_uid

  private

  def set_uid
    self.uid = generate_uid(self.type)
  end
end