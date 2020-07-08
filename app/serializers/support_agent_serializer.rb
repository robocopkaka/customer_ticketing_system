# frozen_string_literal: true

# SupportAgent Serializer
class SupportAgentSerializer < UserSerializer
  attributes :role

  def role
    "Support Agent"
  end
end
