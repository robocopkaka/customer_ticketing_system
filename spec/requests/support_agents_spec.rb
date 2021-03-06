require "rails_helper"

RSpec.describe SupportAgentsController do
  let(:support_agent) { FactoryBot.attributes_for :support_agent }
  let(:admin_session) { create(:session, :for_admin) }
  let(:admin) { admin_session.session_user }

  describe "create" do
    context "when valid parameters are passed" do
      before do
        post support_agents_path,
             params: support_agent,
             headers: authenticated_headers(admin_session.id)
      end

      it "returns the created support_agent" do
        saved_support_agent = json["data"]["user"]
        expect(response).to have_http_status 201
        expect(saved_support_agent["name"]).to eq support_agent[:name]
        expect(saved_support_agent["email"]).to eq support_agent[:email]
        expect(saved_support_agent["phone_number"]).to eq support_agent[:phone_number]
        expect(saved_support_agent["role"]).to eq "Support Agent"
      end
    end

    context "when email has already been taken" do
      before do
        post support_agents_path,
             params: support_agent,
             headers: authenticated_headers(admin.id)
      end
      it "returns an error" do
        post support_agents_path,
             params: support_agent,
             headers: authenticated_headers(admin.id)
        errors = json["errors"].first
        expect(response).to have_http_status 422
        expect(errors["email"]).to include "has already been taken"
      end
    end

    context "when name is not entered" do
      before do
        support_agent.delete(:name)
        post support_agents_path,
             params: support_agent,
             headers: authenticated_headers(admin.id)
      end

      it "returns an error" do
        errors = json["errors"].first
        expect(response).to have_http_status 422
        expect(errors["name"]).to include "can't be blank"
      end
    end
  end

  describe "/support_agents/login" do
    let(:params) do
      {
        email: support_agent[:email],
        password: support_agent[:password]
      }
    end
    before do
      post support_agents_path,
           params: support_agent,
           headers: authenticated_headers(admin_session.id)
    end

    context "when valid login details are used" do
      it "logs in the user and returns a token" do
        post support_agents_login_path, params: params
        returned_session = json["data"]["session"]
        expect(response).to have_http_status 201
        expect(returned_session["active"]).to be true
        expect(returned_session["role"]).to eq "Support agent"
        expect(returned_session["expires_at"]).to be > Time.current
      end
    end

    context "when invalid login details are used" do
      before do
        params[:password] = "random"
        post support_agents_login_path, params: params
      end
      it "returns an error" do
        expect(response).to have_http_status 401
        expect(json["message"]).to eq "Invalid email/password"
      end
    end
  end

  describe "/support_agents" do
    let!(:agents) { FactoryBot.create_list :support_agent, 5 }
    context "when admin tries to access a list of support agents" do
      before { get support_agents_path, headers: authenticated_headers(admin_session.id) }
      it "returns a list of available support agents" do
        support_agents = json["data"]["users"]
        expect(response).to have_http_status 200
        expect(support_agents.count).to eq 5
        expect(support_agents.first["name"]).to eq agents.first.name
      end
    end

    context "when non admin tries to access a list of support agent" do
      let(:agent_session) { create(:session, :for_support_agent) }
      before do
        get support_agents_path, headers: authenticated_headers(agent_session.id)
      end
      it "returns an error" do
        expect(response).to have_http_status 401
      end
    end
  end
end