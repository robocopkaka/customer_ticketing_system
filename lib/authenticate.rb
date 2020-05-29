# frozen_string_literal: true

# Authenticate for different users
module Authenticate
  private

  def method_missing(method, *args)
    klass = method.to_s.split("_").last(2).join("_")
    unless klass.camelize.constantize
      raise NoMethodError.new("Method #{method} does not exist")
    end

    authenticate_user(klass)
  end

  def authenticate_user(klass)
    session_id = request.headers["HTTP_SESSION_ID"]
    unless instance_variable_defined?("@current_#{klass.underscore}")
      session = Session.active.find_by!(uid: session_id)
      user = session.session_user
      # since we're using STI, this ensures that an instance variable
      # is only set if the session user matches the class from the
      # authentication call
      # i.e authenticate_customer should receive session_id with user, cust_....
      unless user.class.to_s.downcase != klass
        instance_variable_set(:"@current_#{klass.underscore}", user)
        return
      end
      render json: {
        message: "You are not authorized to perform this operation"
      }, status: :unauthorized
    end
  end
end
