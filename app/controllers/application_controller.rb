class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Response
  include Error::ErrorHandler
  include Authenticate

  after_action :refresh_session

  private

  def refresh_session
    session_id = request.headers["HTTP_SESSION_ID"]

    return unless session_id
    session ||= Session.active.find_by(id: session_id)
    session.update!(expires_at: session.expires_at + 24.hours)
  end
end
