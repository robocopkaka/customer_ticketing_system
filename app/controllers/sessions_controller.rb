class SessionsController < ApplicationController
  before_action :find_session, only: %i[update refresh destroy]
  def create
    session = SessionService.create(session_params)
    json_response(session, "", :created)
  end

  def track
    authenticate_support_agent
  end

  def update
  end

  def refresh
    @session.update!(expires_at: @session.expires_at + 24.hours)
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

  def find_session
    @session ||= Session.find_by!(id: params[:id])
  end
end
