class CustomerSerializer < ActiveModel::Serializer
  attributes :name, :email, :phone_number
end