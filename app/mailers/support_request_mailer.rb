class SupportRequestMailer < ApplicationMailer
  default from: 'management@kachi-support-system.com'

  def export
    @support_agent = SupportAgent.find_by!(uid: params[:agent_id])
    @filename = params[:filename]
    attachments["requests-#{Time.now}.csv"] = File.read(@filename)

    mail(to: @support_agent.email, subject: "Exported requests")
  end
end
