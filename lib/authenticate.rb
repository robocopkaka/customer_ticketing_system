# frozen_string_literal: true

# Authenticate for different users
module Authenticate
  private

  def method_missing(method, *args)
    klass = method.to_s.split("_").reject {|val| val == "authenticate" }.join("_")
    unless klass.camelize.constantize
      raise NoMethodError.new("Method #{method} does not exist")
    end

    case klass
    when "user"
      authenticate_all
    else
      authenticate_entity(klass)
    end
  end

  def authenticate_entity(klass)
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
      render json: { errors: [{user: ["is unauthorized"]}] },status: :unauthorized
    end
  end

  # should only be used to in specific cases to authenticate
  # regardless of child classes
  def authenticate_all
    session_id = request.headers["HTTP_SESSION_ID"]
    unless instance_variable_defined?("@user")
      session = Session.includes(:session_user).active.find_by!(uid: session_id)
      user = session.session_user

      instance_variable_set(:@user, user)
    end
  end
end
