module Response
  def json_response(object, extra, status=:ok)
    object = ActiveModelSerializers::SerializableResource.new(object).as_json
    response = {
      data: object,
      extra: extra
    }
    render json: response, status: status
  end
end