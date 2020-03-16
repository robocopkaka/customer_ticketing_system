module GenerateUid
  extend ActiveSupport::Concern

  def generate_uid(klass)
    base_klass = klass.constantize
    token = "#{klass[0..3].downcase}-#{SecureRandom.hex}"
    token_exists = base_klass.find_by(uid: token)

    while token_exists
      token = "#{klass[0..3].downcase}-#{SecureRandom.hex}"
      token_exists = base_klass.find_by(uid: token)
    end
    token
  end
end