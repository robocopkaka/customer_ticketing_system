# frozen_string_literal: true

# Authenticate for different users
module Authenticate
  private

  def method_missing(method, *args)
    klass = method.to_s.split("_").reject {|val| val == "authenticate" }.join("_")
    # alternative - use constantize
    super unless klass.in? %w[customer support_agent admin user]

    case klass
    when "user"
      authenticate_all
    else
      authenticate_entity(klass.camelize)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("authenticate_") || super
  end

  def authenticate_entity(klass)
    session_id = request.headers["HTTP_SESSION_ID"]
    return if instance_variable_defined?("@current_#{klass.underscore}")

    session = Session.active.find_by!(uid: session_id)
    user = User.where(uid: session.session_user_id, type: klass.capitalize).first

    unless user
      render json: { errors: [{ user: ["is unauthorized"] }] },status: :unauthorized
    end

    instance_variable_set(:"@current_#{klass.underscore}", user)
  end

  # should only be used to in specific cases to authenticate
  # regardless of child classes
  def authenticate_all
    session_id = request.headers["HTTP_SESSION_ID"]
    return if instance_variable_defined?("@user")

    session = Session.active.find_by!(uid: session_id)
    user = session.session_user

    instance_variable_set(:@user, user)
  end
end
