module Error::Helpers
  class Render
    def self.json(error, status, messages)
      {
        errors: [
          {
            status: status,
            error: error,
            messages: messages
          }
        ]
      }.as_json
    end

    def self.json_invalid_record(messages)
      { errors: [messages] }.as_json
    end
  end
end