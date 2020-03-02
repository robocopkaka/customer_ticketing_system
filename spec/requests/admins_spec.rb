require "rails_helper"

RSpec.describe AdminsController, type: :request do
  let!(:admin) { FactoryBot.create :admin }
  let(:support_request) { FactoryBot.create :support_request }
  let(:support_agent) { FactoryBot.create :support_agent }
  let(:customer) { FactoryBot.create :customer }

  describe "/admins/login" do
    let(:params) do
      {
        auth: {
          email: admin[:email],
          password: "password",
        }
      }
    end

    context "when valid login details are used" do
      it "logs in the user and returns a token" do
        post admins_login_path, params: params
        expect(response).to have_http_status 201
        expect(json).to have_key "jwt"
      end
    end

    context "when invalid login details are used" do
      before do
        params[:auth][:password] = "random"
        post admins_login_path, params: params
      end
      it "returns an error" do
        expect(response).to have_http_status 404
      end
    end
  end

  describe "patch /support_requests/:id/assign" do
    let(:params) { { assignee_id: support_agent.uid } }

    context "when a valid support agent id is passed" do
      before do
        ActionMailer::Base.deliveries.clear
        patch assign_support_request_path(support_request.id),
              headers: authenticated_headers(admin.id),
              params: params
      end
      it "assigns the request to a support agent" do
        returned_request = json["data"]["support_request"]
        expect(response).to have_http_status 200
        expect(returned_request["status"]).to eq "assigned"
        expect(returned_request["assignee_id"]).to eq support_agent.id
      end

      it "sends a mail" do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context "when an invalid support agent id is passed" do
      before do
        params[:assignee_id] = customer.id
        patch assign_support_request_path(support_request.id),
              headers: authenticated_headers(admin.id),
              params: params
      end
      it "returns an error" do
        errors = json["errors"].first
        expect(response).to have_http_status 404
        expect(errors["messages"]).to eq "Resource was not found"
      end
    end
  end
end