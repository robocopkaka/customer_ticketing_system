require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  let(:customer_id) { FactoryBot.create(:customer).id }
  let(:support_request_id) { FactoryBot.create(:support_request).id }

  describe "open_request" do
    context "when the method is called" do
      it "delivers a mail" do
        expect do
          CustomerMailer
            .with(customer_id: customer_id,
                  support_request_id: support_request_id
            ).open_request.deliver_later
        end.to change(ActionMailer::Base.deliveries, :size).by 1
      end

      it "has the correct details" do
        customer = Customer.find(customer_id)
        support_request = SupportRequest.find(support_request_id)
        email = CustomerMailer
                  .with(customer_id: customer_id,
                        support_request_id: support_request_id
                  ).open_request

        expect(email.from).to include "management@kachi-support-system.com"
        expect(email.bcc).to include customer.email
        expect(email.subject).to include support_request.subject
        expect(email.body.to_s).to include customer.name
      end
    end
  end
end
