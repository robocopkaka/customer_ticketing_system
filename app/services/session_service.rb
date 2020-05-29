# frozen_string_literal: true

# handle session logic here
class SessionService
  class << self
    def create(params)
      base_klass = params[:role].camelize.constantize
      user = base_klass.find_by!(email: params[:email])
      user.authenticate(params[:password]) if params[:password]
      raise ActiveRecord::RecordNotFound unless user

      user.sessions.create!(user_agent: params[:user_agent])
    end
  end
end
