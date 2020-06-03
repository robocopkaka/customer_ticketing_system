require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:session_params) { attributes_for(:session) }
  let(:session) { create(:session, :for_customer) }
  let(:customer) { session.session_user }
  let(:session_2) { create(:session, :for_customer) }


  describe "#destroy" do
    context "when user owns the session" do
      before do
        delete session_path(session), headers: authenticated_headers(session.id)
      end
      it "soft deletes the session" do
        returned_session = json["data"]["session"]
        expect(response).to have_http_status 200
        expect(returned_session["active"]).to be false
        expect(returned_session["deleted"]).to be true
        expect(returned_session["deleted_at"]).to_not be nil
        expect(Session.active.map(&:id)).to_not include returned_session["id"]
      end
    end

    context "when user does not own the session" do
      before do
        delete session_path(session), headers: authenticated_headers(session_2.id)
      end

      it "returns an error" do
        expect(response).to have_http_status 401
        expect(json["errors"].first["user"]).to include "is unauthorized"
      end
    end

    context "when an invalid ID is passed" do
      before do
        delete session_path(session), headers: authenticated_headers("sess-1a4f11ec127ffd3f003d11ce83865")
      end

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"].first["messages"]).to eq "Session was not found"
      end
    end
  end

  describe "#show" do
    context "when user owns the session and a valid ID is passed" do
      before do
        get session_path(session), headers: authenticated_headers(session.id)
      end
      it "returns the session" do
        returned_session = json["data"]["session"]
        expect(response).to have_http_status 200
        expect(returned_session["active"]).to be true
        expect(returned_session["user_id"]).to eq customer.id
        expect(Session.active.map(&:id)).to include returned_session["id"]
      end
    end

    context "when user does not own the session" do
      before do
        get session_path(session), headers: authenticated_headers(session_2.id)
      end

      it "returns an error" do
        expect(response).to have_http_status 401
        expect(json["errors"].first["user"]).to include "is unauthorized"
      end
    end

    context "when an invalid ID is passed" do
      before do
        get session_path(session), headers: authenticated_headers("sess-1a4f11ec127ffd3f003d11ce83865")
      end

      it "returns an error" do
        expect(response).to have_http_status 404
        expect(json["errors"].first["messages"]).to eq "Session was not found"
      end
    end
  end

  describe "#index" do
    let!(:list_customer) { create(:customer_with_sessions) }
    let(:list_session_id) { list_customer.sessions.first.id }

    before do
      get sessions_path, headers: authenticated_headers(list_session_id)
    end

    it "returns the user's sessions" do
      returned_sessions = json["data"]["sessions"]
      expect(response).to have_http_status 200
      expect(returned_sessions.count).to eq 10 # set in customer factory
      customer_ids = json["data"]["sessions"].pluck("user_id").uniq
      expect(customer_ids.count).to eq 1
      expect(customer_ids).to include list_customer.id
    end
  end
end