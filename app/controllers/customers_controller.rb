class CustomersController < ApplicationController
  def create
    customer = Customer.create!(customer_params)
    # using association `create` instead of service here
    customer.sessions.create!(user_agent: request.headers["HTTP_USER_AGENT"])
    json_response(
      customer,
      { session_id: customer.sessions.last.id },
      :created
    )
  end

  private

  def customer_params
    params
      .permit(
      :name,
      :email,
      :phone_number,
      :password,
      :password_confirmation
      )
  end
end
