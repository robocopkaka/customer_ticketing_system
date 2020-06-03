module RequestSpecHelper
  # Parse JSON response to Ruby Hash
  def json
    JSON.parse(response.body)
  end

  def authenticated_headers(id)
    { HTTP_SESSION_ID: id }
  end
end