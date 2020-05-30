class SessionsController < ApplicationController
  skip_after_action :refresh_session, only: %i[create index destroy]
  before_action :find_session, only: %i[update refresh destroy show]
  # authenticate customer before retrieving index
  def create
    session = SessionService.create(session_params)
    json_response(session, "", :created)
  end

  def track
    authenticate_support_agent
  end

  def update
    @session.update!(session_params)
    json_response(@session, "")
  end

  def index
    sessions = Session.active.all
    json_response(sessions, "")
  end

  def show
    json_response(@session, "")
  end

  def destroy
    @session.update!(deleted_at: Time.current)
    json_response(@session, "")
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
    @session ||= Session.active.find_by!(uid: params[:id])
  end
end
