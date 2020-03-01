require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let(:assignee) { FactoryBot.create(:support_agent) }
  let!(:admins) { FactoryBot.create_list(:admin, 5) }
  let(:support_request_id) { FactoryBot.create(:support_request).id }
  describe "assign_request" do
    context "when the method is called" do
      it "delivers the mail" do
        expect do
          AdminMailer
            .with(assignee_id: assignee.id, support_request_id: support_request_id)
            .assign_request
            .deliver_later
        end.to change(ActionMailer::Base.deliveries, :size).by 1
      end

      it "sends out the correct email details" do
        email = AdminMailer
                  .with(assignee_id: assignee.id, support_request_id: support_request_id)
                  .assign_request
        expect(email.from).to include "management@kachi-support-system.com"
        expect(email.to).to include assignee.email
        expect(email.bcc).to include admins.first.email
      end
    end
  end

end
