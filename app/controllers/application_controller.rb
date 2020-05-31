class ApplicationController < ActionController::API
  include Response
  include Error::ErrorHandler
  include Authenticate

  after_action :refresh_session

  private

  def refresh_session
    session_id = request.headers["HTTP_SESSION_ID"]

    session ||= Session.active.find_by(uid: session_id)
    return unless session
    session.update!(expires_at: session.expires_at + 24.hours)
  end
end
