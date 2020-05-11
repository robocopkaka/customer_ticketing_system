require "rails_helper"

RSpec.describe SupportRequestService, type: :service do
  let(:customer) { FactoryBot.create(:customer) }
  let(:admin) { FactoryBot.create(:admin) }
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
      it "returns the request with the assigned id" do
        sp = SupportRequestService
               .new
               .assign_request(
                 assignee_id: support_agent.id, request_id: support_request.id
               )
        expect(sp.assignee_id).to eq support_agent.id
        expect(sp.assignee_id).to eq SupportRequest.last.assignee_id
      end
    end
  end

  describe "self.fetch_request" do
    let!(:assigned_requests)  { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id, status: 'resolved') }
    let!(:opened_requests)  { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id, status: 'opened') }

    context "when a query string is present" do
      it "returns a matching result set" do
        sp = SupportRequestService.fetch_requests(support_agent, "opened")
        expect(sp.count).to eq 5
        statuses = sp.pluck(:status).uniq
        expect(statuses.count).to eq 1
        expect(statuses).to include "opened"
      end
    end

    context "when a query string is not present" do
      it "returns a matching result set" do
        sp = SupportRequestService.fetch_requests(support_agent)
        expect(sp.count).to eq 10
      end
    end

    context "when an invalid status is passed as a query" do
      it "returns an empty result set" do
        sp = SupportRequestService.fetch_requests(support_agent, "weird")
        expect(sp.count).to eq 0
      end
    end
  end

  describe ".group_by_priority" do
    let!(:requests) { FactoryBot.create_list(:support_request, 20) }
    context "when a call is made" do
      it "returns requests grouped by priority" do
        requests = SupportRequestService.group_by_priority(admin)
        expect(requests).to be_a Hash
        expect(requests).to have_key "low"
        expect(requests).to have_key "normal"
        expect(requests).to have_key "high"
        total_count = 0
        requests.each_value { |value| total_count += value.count }
        expect(total_count).to eq 20
      end
    end
  end
end