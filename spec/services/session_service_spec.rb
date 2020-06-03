require "rails_helper"

RSpec.describe SessionService, type: :service do
  let(:customer) { create(:customer) }
  let(:params) do
    {
      email: customer[:email],
      password: "password",
      role: "customer",
      user_agent: "Brave"
    }
  end

  describe ".create" do
    context "when params are valid" do
      it "creates a new session" do
        expect do
          session = SessionService.create(params)
          expect(session.session_user_id).to eq customer.id
          expect(session.user_agent).to eq params[:user_agent]
          expect(session.expires_at).to be > Time.current + 23.hours
        end.to change(Session, :count).by 1
      end
    end

    context "when password is invalid" do
      it "returns false" do
        params[:password] = "new"
        session = SessionService.create(params)
        expect(session).to be false
      end
    end

    context "when email is invalid" do
      it "raises an error" do
        params[:email] = "test"
        expect do
          SessionService.create(params)
        end.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end