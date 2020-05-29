class SessionsController < ApplicationController
  def create
    session = SessionService.create(session_params)
    json_response(session, "", :created)
  end

  def track
    authenticate_support_agent
  end

  def update
  end

  private

  def session_params
    agent = request.headers["HTTP_USER_AGENT"]
    user_agent = agent.present? ? { user_agent: agent } : {}
    role = { role: request.headers["REQUEST_PATH"].split("/")[1].singularize }
    params
      .permit(:email, :password)
      .merge(role)
      .merge(user_agent)
  end
end
