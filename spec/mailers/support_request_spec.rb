require "rails_helper"

RSpec.describe SupportRequestMailer, type: :mailer do
  let(:support_agent) { FactoryBot.create(:support_agent) }
  let(:filename) { "spec/fixtures/file.csv" }

  describe "export" do
    context "when the method is called" do
      it "delivers the mail" do
        expect do
          SupportRequestMailer
            .with(agent_id: support_agent.id, filename: filename)
            .export
            .deliver_later
        end.to change(ActionMailer::Base.deliveries, :size).by 1
      end

      it "sends out the correct email details" do
        email = SupportRequestMailer
                  .with(agent_id: support_agent.id, filename: filename)
                  .export
        expect(email.from).to include "management@kachi-support-system.com"
        expect(email.to).to include support_agent.email
        expect(email.attachments.count).to be 1
      end
    end
  end
end
