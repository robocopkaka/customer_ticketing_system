class CustomersController < ApplicationController
  skip_after_action :refresh_session
  def create
    customer = Customer.create!(customer_params)
    # using association `create` instead of service here
    customer.sessions.create!(user_agent: request.headers["HTTP_USER_AGENT"])
    json_response(
      object: customer,
      extra: {
        session_id: customer.sessions.last.id,
        expires_at: customer.sessions.last.expires_at
      },
      options: { root: "user" },
      status: :created
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
