class SupportAgentsController < ApplicationController
  def create
    support_agent = SupportAgent.create!(support_agent_params)
    json_response(
      support_agent,
      "Support agent created successfully",
      :created
    )
  end

  private

  def support_agent_params
    params.permit(
      :name,
      :email,
      :phone_number,
      :password,
      :password_confirmation,
    )
  end
end
