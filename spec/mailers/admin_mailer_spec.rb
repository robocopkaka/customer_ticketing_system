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

  describe "#no_available_agents" do
    context "when the mailer is called" do
      it "delivers the mail" do
        expect do
          AdminMailer
            .with(support_request_id: support_request_id)
            .no_available_agent
            .deliver_later
        end.to change(ActionMailer::Base.deliveries, :size).by 1
      end

      it "sends out the correct email body" do
        email = AdminMailer
          .with(support_request_id: support_request_id)
          .no_available_agent
        # binding.pry
        admin_emails = Set.new(admins.pluck(:email))
        to_emails = Set.new(email.to)
        expect(to_emails).to eq admin_emails
        expect(email.subject).to eq "No available agent"
        expect(email.body.to_s).to include support_request_id
      end
    end
  end

end
