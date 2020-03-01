require 'rails_helper'

RSpec.describe SupportRequest, type: :model do
  describe "validations" do
    it { should validate_presence_of :subject }
    it { should validate_presence_of :description }
  end

  describe "status enum" do
    subject { FactoryBot.build(:support_request) }

    context "when status is invalid" do
      it "raises an error" do
        expect do
          subject.status = "echo"
        end.to raise_error ArgumentError
      end
    end
  end
end
