module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e.to_s)
        end
        rescue_from ActiveRecord::RecordInvalid do |e|
          respond_invalid_record(422, e.record.errors)
        end
        rescue_from ActiveRecord::RecordNotUnique do |e|
          respond(:conflict, 409, e.to_s)
        end
        rescue_from ActiveRecord::RecordNotFound do
          respond(:not_found, 404, "Resource was not found")
        end
      end
    end

    private

    def respond(error, status, messages)
      json = Helpers::Render.json(error, status, messages)
      render json: json, status: status
    end

    def respond_invalid_record(status, messages)
      json = Helpers::Render.json_invalid_record(messages)
      render json: json, status: status
    end
  end
end