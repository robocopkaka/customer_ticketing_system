class AdminMailer < ApplicationMailer
  default from: 'management@kachi-support-system.com'

  def assign_request
    @support_agent = SupportAgent.find_by!(uid: params[:assignee_id])
    @support_request_id = params[:support_request_id]
    admin_emails = Admin.all.pluck(:email)
    mail(to: @support_agent.email,
         subject: "New assigned request",
         bcc: admin_emails
    )
  end
end
