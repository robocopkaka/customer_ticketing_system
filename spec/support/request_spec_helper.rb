module RequestSpecHelper
  # Parse JSON response to Ruby Hash
  def json
    JSON.parse(response.body)
  end

  def authenticated_headers(id)
    token = Knock::AuthToken.new(payload: { sub: id }).token
    { 'Authorization': "Bearer #{token}" }
  end
end