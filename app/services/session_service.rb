# frozen_string_literal: true

# handle session logic here
class SessionService
  class << self
    def create(params)
      return false unless params[:role].in? %w(admin customer support_agent)
      
      base_klass = params[:role].camelize.constantize
      user = base_klass.find_by!(email: params[:email])
      return false unless user.authenticate(params[:password])

      user.sessions.create!(user_agent: params[:user_agent])
    end
  end
end
