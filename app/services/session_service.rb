# frozen_string_literal: true

# handle session logic here
class SessionService
  class << self
    def create(params, klass)
      base_klass = klass.constantize
      user = base_klass
        .find_by!(email: params[:email])
        .authenticate(params[:password])
      binding.pry
    end

    define_method
  end
end
