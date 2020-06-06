class SessionsController < ApplicationController
  skip_after_action :refresh_session, only: %i[create index destroy]
  before_action :authenticate_user, except: %i[new edit create]
  before_action :find_session, only: %i[update refresh destroy show]
  before_action :is_owned_by_user?, only: %i[update show destroy]

  def create
    session = SessionService.create(session_params)
    unless session
      render json: { message: "Invalid email/password" }, status: :unauthorized
      return
    end
    json_response(object: session, status: :created)
  end

  def index
    sessions = @user.active_sessions
    json_response(object: sessions)
  end

  def show
    json_response(object: @session)
  end

  def destroy
    @session.update!(deleted_at: Time.current)
    json_response(object: @session)
  end

  private

  def session_params
    agent = request.headers["HTTP_USER_AGENT"]
    user_agent = agent.present? ? { user_agent: agent } : {}
    role = { role: request.headers["REQUEST_URI"].split("/")[1].singularize }
    params
      .permit(:email, :password)
      .merge(role)
      .merge(user_agent)
  end

  def find_session
    @session ||= Session.active.find_by!(uid: params[:id])
  end

  def is_owned_by_user?
    unless @session.session_user_id == @user.id
      render json: { errors: [{user: ["is unauthorized"]}] },status: :unauthorized
    end
  end
end
