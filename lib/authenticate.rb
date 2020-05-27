# frozen_string_literal: true

# Authenticate for different users
module Authenticate
  private

  def method_missing(method, *args)
    prefix, klass = method.to_s.split("_")
    unless klass.in?(["customer", "admin", "support_agent"])
      raise NoMethodError.new("Method #{method} does not exist")
    end

    authenticate_klass(klass)

    p prefix if prefix == "authenticate"
    p klass if prefix == "authenticate"
  end

  def authenticate_klass(klass)
    binding.pry
    base_klass = klass.camelize.constantize
    user = base_klass
             .find_by!(email: params[:email])
             .authenticate(params[:password])
    binding.pry
  end
end
