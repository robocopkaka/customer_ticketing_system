require "rails_helper"

RSpec.describe SupportRequestService, type: :service do
  let(:customer) { FactoryBot.create(:customer) }
  let(:support_request) { FactoryBot.create(:support_request) }
  let(:support_agent) { FactoryBot.create(:support_agent) }
  let(:params) { FactoryBot.attributes_for(:support_request) }

  describe "create" do
    context "when valid parameters are passed" do
      it "creates a support request" do
        sp = SupportRequestService
               .new(customer: customer, request_params: params)
               .create
        expect(sp.id).to eq SupportRequest.last.id
        expect(sp.subject).to eq SupportRequest.last.subject
      end
    end

    context "when invalid parameters are passed" do
      before do
        params.delete(:subject)
      end
      it "raises an error" do
        expect do
          SupportRequestService
            .new(customer: customer, request_params: params)
            .create
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "assign_request" do
    context "when a support request is assigned" do
      before { params[:assignee_id] = support_agent.id }
      it "returns the request with the assigned id" do
        sp = SupportRequestService
               .new(request_params: params, support_request: support_request)
               .assign_request
        expect(sp.assignee_id).to eq support_agent.id
        expect(sp.assignee_id).to eq SupportRequest.last.assignee_id
      end
    end
  end
end