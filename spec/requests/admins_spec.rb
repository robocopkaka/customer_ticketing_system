require "rails_helper"

RSpec.describe AdminsController do
  let!(:admin) { FactoryBot.create :admin }

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
end