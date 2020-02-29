class CustomersController < ApplicationController
  def create
    customer = Customer.create!(customer_params)
    json_response(
      customer,
      "Customer created successfully",
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
