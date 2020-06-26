# frozen_string_literal: true

# Base user serializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_number, :role
end
