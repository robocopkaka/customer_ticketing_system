class SupportAgentsController < ApplicationController
  skip_after_action :refresh_session, only: :create
  before_action :authenticate_admin, only: %i[index]
  def create
    support_agent = SupportAgent.create!(support_agent_params)
    support_agent.sessions.create!(user_agent: request.headers["HTTP_USER_AGENT"])
    json_response(
      support_agent,
      { session_id: support_agent.sessions.last.id },
      :created
    )
  end

  def index
    json_response(SupportAgent.all, "")
  end

  private

  def support_agent_params
    params.permit(
      :name,
      :email,
      :phone_number,
      :password,
      :password_confirmation,
    )
  end
end
