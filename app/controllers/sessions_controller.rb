class SessionsController < ApplicationController
  def create
    session = SessionService.create(session_params, klass)
    json_response(session, "")
  end

  def track
    authenticate_customer
  end

  def update
  end
end
