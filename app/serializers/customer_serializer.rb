class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_number

  def id
    object.uid
  end
end