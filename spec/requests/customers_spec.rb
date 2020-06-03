require "rails_helper"

RSpec.describe CustomersController do
  let(:customer) { FactoryBot.attributes_for :customer }

  describe "create" do
    context "when valid parameters are passed" do
      before { post customers_path, params: customer }

      it "returns the created customer" do
        saved_customer = json["data"]["customer"]
        expect(response).to have_http_status 201
        expect(saved_customer["name"]).to eq customer[:name]
        expect(saved_customer["email"]).to eq customer[:email]
        expect(saved_customer["phone_number"]).to eq customer[:phone_number]
      end
    end

    context "when email has already been taken" do
      before { post customers_path, params: customer }
      it "returns an error" do
        post customers_path, params: customer
        errors = json["errors"].first
        expect(response).to have_http_status 422
        expect(errors["email"]).to include "has already been taken"
      end
    end

    context "when name is not entered" do
      before do
        customer.delete(:name)
        post customers_path, params: customer
      end

      it "returns an error" do
        errors = json["errors"].first
        expect(response).to have_http_status 422
        expect(errors["name"]).to include "can't be blank"
      end
    end
  end

  describe "/customers/login" do
    let(:params) do
      {
        email: customer[:email],
        password: customer[:password]
      }
    end
    before { post customers_path, params: customer }

    context "when valid login details are used" do
      it "logs in the user and returns a token" do
        post customers_login_path, params: params
        returned_session = json["data"]["session"]
        expect(response).to have_http_status 201
        expect(returned_session["active"]).to be true
        expect(returned_session["role"]).to eq "Customer"
        expect(returned_session["expires_at"]).to be > Time.current
      end
    end

    context "when invalid login details are used" do
      before do
        params[:password] = "random"
        post customers_login_path, params: params
      end
      it "returns an error" do
        expect(response).to have_http_status 401
        expect(json["message"]).to eq "Invalid email/password"
      end
    end
  end
end