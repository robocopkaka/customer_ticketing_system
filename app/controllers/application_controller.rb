class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Response
  include Error::ErrorHandler
  include Authenticate
end
