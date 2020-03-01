require "rails_helper"

RSpec.describe SupportRequestsController, type: :request do
  let(:support_request) { FactoryBot.attributes_for(:support_request) }
  let(:created_request) { FactoryBot.create(:support_request) }
  let(:customer) { FactoryBot.create(:customer) }

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
        expect(returned_request["status"]).to eq "opened"
        expect(returned_request["requester_id"]).to eq customer.id
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
end