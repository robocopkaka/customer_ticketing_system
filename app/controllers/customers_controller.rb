class CustomersController < ApplicationController
  def create
    customer = Customer.create!(customer_params)
    auth_token = Knock::AuthToken.new payload: { sub: customer.id }
    json_response(
      customer,
      { jwt: auth_token.token },
      :created
    )
  end

  private

  def customer_params
    params.permit(
      :name,
      :email,
      :phone_number,
      :password,
      :password_confirmation
      )
  end
end
