require "rails_helper"

RSpec.describe AdminsController, type: :request do
  let(:admin_session) { create(:session, :for_admin) }
  let!(:admin) { FactoryBot.create :admin }
  let(:support_request) { FactoryBot.create :support_request }
  let(:support_agent) { FactoryBot.create :support_agent }
  let(:customer) { FactoryBot.create :customer }

  describe "/admins/login" do
    let(:params) do
      {
        email: admin[:email],
        password: "password"
      }
    end

    context "when valid login details are used" do
      it "logs in the user and returns a token" do
        post admins_login_path, params: params
        returned_session = json["data"]["session"]
        expect(response).to have_http_status 201
        expect(returned_session["active"]).to be true
        expect(returned_session["role"]).to eq "Admin"
        expect(returned_session["expires_at"]).to be > Time.current
      end
    end

    context "when invalid login details are used" do
      before do
        params[:password] = "random"
        post admins_login_path, params: params
      end
      it "returns an error" do
        expect(response).to have_http_status 401
        expect(json["message"]).to eq "Invalid email/password"
      end
    end
  end

  describe "patch /support_requests/:id/assign" do
    let(:params) { { assignee_id: support_agent.uid } }

    context "when a valid support agent id is passed" do
      before do
        ActionMailer::Base.deliveries.clear
        patch assign_support_request_path(support_request.id),
              headers: authenticated_headers(admin_session.id),
              params: params
      end
      it "assigns the request to a support agent" do
        returned_request = json["data"]["support_request"]
        expect(response).to have_http_status 200
        expect(returned_request["status"]).to eq "Assigned"
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
              headers: authenticated_headers(admin_session.id),
              params: params
      end
      it "returns an error" do
        errors = json["errors"].first
        expect(response).to have_http_status 404
        expect(errors["support_agent"]).to eq "was not found"
      end
    end
  end
end