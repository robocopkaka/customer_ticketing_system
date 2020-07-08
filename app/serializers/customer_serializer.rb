class CustomerSerializer < UserSerializer
  attributes :role

  def role
    "Customer"
  end
end
