module GenerateUid
  extend ActiveSupport::Concern

  def generate_uid(klass)
    base_klass = klass.constantize
    token = "#{set_identifier(klass)}-#{SecureRandom.hex}"
    token_exists = base_klass.find_by(uid: token)

    while token_exists
      token = "#{set_identifier(klass)}-#{SecureRandom.hex}"
      token_exists = base_klass.find_by(uid: token)
    end
    token
  end

  private

  def set_identifier(klass)
    return "request" if klass == "SupportRequest"

    klass[0..3].downcase
  end
end