module Response
  def json_response(object, message, status=:ok)
    object = ActiveModelSerializers::SerializableResource.new(object).as_json
    response = {
      data: object,
      message: message
    }
    render json: response, status: status
  end
end