require "rails_helper"

RSpec.describe SupportRequestsController, type: :request do
  let(:support_request) { FactoryBot.attributes_for(:support_request) }
  let(:created_request) { FactoryBot.create(:support_request) }
  let(:customer) { FactoryBot.create(:customer) }
  let(:support_agent) { FactoryBot.create(:support_agent) }

  describe "post /support_requests" do
    context "when valid parameters are passed" do
      before do
        ActionMailer::Base.deliveries.clear
        post support_requests_path,
             params: support_request,
             headers: authenticated_headers(customer.id)
      end
      it "creates the request" do
        returned_request = json["data"]["support_request"]
        expect(response).to have_http_status(201)
        expect(returned_request["status"]).to eq "Opened"
        expect(returned_request["requester_id"]).to eq customer.id
        expect(returned_request["priority"]).to eq "normal"
        expect(SupportRequest.last.description).to eq support_request[:description]
      end

      it "sends a mail" do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context "when customer is not logged in" do
      before { post support_requests_path, params: support_request }

      it "returns an unauthorized error" do
        expect(response).to have_http_status 401
      end
    end

    context "when invalid parameters are passed" do
      before do
        support_request.delete(:subject)
        post support_requests_path,
             params: support_request,
             headers: authenticated_headers(customer.id)
      end
      it "returns an error" do
        subject = json["errors"].first["subject"]
        expect(response).to have_http_status 422
        expect(subject).to include "can't be blank"
      end
    end
  end

  describe "get /support_requests/:id" do
    context "when a valid request id is passed" do
      before { get support_request_path(created_request.id) }
      it "returns the support request" do
        returned_request = json["data"]["support_request"]
        expect(response).to have_http_status(200)
        expect(returned_request["subject"]).to eq created_request.subject
        expect(returned_request["id"]).to eq created_request.id
      end
    end

    context "when an invalid request id is passed" do
      before { get support_request_path(1001) }
      it "returns an error" do
        errors = json["errors"].first
        expect(response).to have_http_status 404
        expect(errors["messages"]).to eq "Resource was not found"
      end
    end
  end

  describe "/customers/:customer_id/requests" do
    let!(:new_requests) { FactoryBot.create_list(:support_request, 5, requester_id: customer.id) }
    context "when a valid customer id is passed" do
      before do
        get customer_support_requests_path(customer.id),
            headers: authenticated_headers(customer.id)
      end
      it "returns the appropriate requests" do
        returned_requests = json["data"]["support_requests"]
        expect(response).to have_http_status  200
        expect(returned_requests.count).to eq 5
        statuses = returned_requests.pluck("status")
        expect(statuses.uniq.count).to eq 1
      end
    end
  end

  describe "get /support_agents/:support_agent_id/requests" do
    let!(:new_requests) { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id) }
    context "when a valid support agent id is passed" do
      before do
        get support_agent_support_requests_path(support_agent.id),
            headers: authenticated_headers(support_agent.id)
      end
      it "returns the appropriate requests" do
        returned_requests = json["data"]["support_requests"]
        expect(response).to have_http_status  200
        expect(returned_requests.count).to eq 5
        statuses = returned_requests.pluck("status")
        expect(statuses.uniq.count).to eq 1
      end
    end
  end

  describe "query string" do
    let!(:assigned_requests)  { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id, status: 'resolved') }
    let!(:opened_requests)  { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id, status: 'opened') }

    context "when query string is present" do
      before do
        get support_agent_support_requests_path(support_agent.id),
            headers: authenticated_headers(support_agent.id),
            params: { query: 'opened' }
      end

      it "returns only requests matching the query string" do
        returned_requests = json["data"]["support_requests"]
        expect(response).to have_http_status 200
        expect(returned_requests.count).to eq 5
        statuses = returned_requests.pluck("status").uniq
        expect(statuses.count).to eq 1
        expect(statuses).to include "Opened"
      end
    end

    context "when no query sting is passed" do
      before do
        get support_agent_support_requests_path(support_agent.id),
            headers: authenticated_headers(support_agent.id)
      end

      it "returns all the support requests" do
        returned_requests = json["data"]["support_requests"]
        expect(response).to have_http_status 200
        expect(returned_requests.count).to eq 10
      end
    end

    context "when an invalid query string is passed" do
      before do
        get support_agent_support_requests_path(support_agent.id),
            headers: authenticated_headers(support_agent.id),
            params: { query: 'weird' }
      end

      it "returns an empty result set" do
        returned_requests = json["data"]["support_requests"]
        expect(response).to have_http_status 200
        expect(returned_requests.count).to eq 0
      end
    end
  end

  describe "#resolve" do
    context "when request is made to resolve a request" do
      before do
        created_request.update(assignee_id: support_agent.id)
        patch resolve_support_request_path(created_request.id),
              headers: authenticated_headers(support_agent.id)
      end

      it "marks the request as resolved" do
        returned_request = json["data"]["support_request"]
        expect(response).to have_http_status 200
        expect(returned_request["status"]).to eq "Resolved"
        expect(returned_request["resolved_at"]).to_not be nil
      end
    end
  end

  describe "#export_as_csv" do
    context "when a request is made" do
      before do
        get export_support_requests_path,
            headers: authenticated_headers(support_agent.id)
      end
      it "calls the worker and returns a response" do
        expect(response).to have_http_status 200
        expect(json["extra"]).to eq "Generated requests have been sent to your mail"
      end
    end
  end

  describe "#group_by_priority" do
    let!(:requests) { FactoryBot.create_list(:support_request, 20) }
    let(:admin_id) { FactoryBot.create(:admin).id }
    context "when a request is made to return requests by priorities" do
      before do
        get priorities_support_requests_path,
            headers: authenticated_headers(admin_id)
      end
      it "returns a hash of grouped requests" do
        expect(response).to have_http_status 200
        expect(json["data"]).to have_key "low"
        expect(json["data"]).to have_key "high"
        expect(json["data"]).to have_key "normal"

        high_priorities = json["data"]["high"]["support_requests"]
        expect(high_priorities.pluck("priority").uniq).to eq ["high"]
      end
    end
  end
end