class CustomerMailer < ApplicationMailer
  default from: 'management@kachi-support-system.com'
  def open_request
    @customer = Customer.find(params[:customer_id])
    @support_request = SupportRequest.find(params[:support_request_id])
    @admins_email = Admin.all.pluck(:email)
    mail(to: @admins_email, bcc: @customer.email, subject: @support_request.subject)
  end
end
