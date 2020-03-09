class SupportRequestMailer < ApplicationMailer
  default from: 'management@kachi-support-system.com'

  def export
    @support_agent = SupportAgent.find_by!(uid: params[:agent_id])
    @filename = params[:filename]
    attachments["#{@filename}.csv"] = File.read(@filename)

    mail(to: @support_agent.email)
  end
end
