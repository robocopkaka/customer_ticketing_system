module Response
  def json_response(object:nil, extra: nil, options: {}, status: :ok)
    if object.is_a? Hash
      object.transform_values! do |value|
        ActiveModelSerializers::SerializableResource.new(value, options).as_json
      end
    end

    object = ActiveModelSerializers::SerializableResource.new(object, options).as_json
    response = {
      data: object,
      extra: extra
    }
    render json: response, status: status
  end
end