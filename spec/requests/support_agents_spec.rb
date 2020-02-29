require "rails_helper"

RSpec.describe SupportAgentsController do
  let(:support_agent) { FactoryBot.attributes_for :support_agent }

  describe "create" do
    context "when valid parameters are passed" do
      before { post support_agents_path, params: support_agent }

      it "returns the created support_agent" do
        saved_support_agent = json["data"]["support_agent"]
        expect(response).to have_http_status 201
        expect(saved_support_agent["name"]).to eq support_agent[:name]
        expect(saved_support_agent["email"]).to eq support_agent[:email]
        expect(saved_support_agent["phone_number"]).to eq support_agent[:phone_number]
      end
    end

    context "when email has already been taken" do
      before { post support_agents_path, params: support_agent }
      it "returns an error" do
        post support_agents_path, params: support_agent
        errors = json["errors"].first
        expect(response).to have_http_status 422
        expect(errors["email"]).to include "has already been taken"
      end
    end

    context "when name is not entered" do
      before do
        support_agent.delete(:name)
        post support_agents_path, params: support_agent
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
        auth: {
          email: support_agent[:email],
          password: support_agent[:password],
        }
      }
    end
    before { post support_agents_path, params: support_agent }

    context "when valid login details are used" do
      it "logs in the user and returns a token" do
        post support_agents_login_path, params: params
        expect(response).to have_http_status 201
        expect(json).to have_key "jwt"
      end
    end

    context "when invalid login details are used" do
      before do
        params[:auth][:password] = "random"
        post support_agents_login_path, params: params
      end
      it "returns an error" do
        expect(response).to have_http_status 404
      end
    end
  end
end