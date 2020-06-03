require "rails_helper"

RSpec.describe Authenticate do
  include Authenticate
  let(:session) { create(:session) }
  let(:headers) { HashWithIndifferentAccess.new(HTTP_SESSION_ID: session.id) }
  let(:controller) { ApplicationController.new }

  before do
    allow(controller.request).to receive(:headers).and_return headers
  end
  context "when entity method name propagated to method_missing is a valid user model" do
    it "authenticates correctly" do
      user = controller.send(:authenticate_customer)
      expect(user.id).to eq session.session_user_id
    end
  end

  context "when authenticate_user is called" do
    it "authenticates correctly" do
      user = controller.send(:authenticate_user)
      expect(user.id).to eq session.session_user_id
    end
  end

  context "when wrong entity name is passed" do
    it "raises an error" do
      expect do
        authenticate_kachi
      end
        .to raise_exception(NameError)
    end
  end

  # TODO: add spec that confirms that error is rendered if entity being authenticated does not match entity clas in session
end