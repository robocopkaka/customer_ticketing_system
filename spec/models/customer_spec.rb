require "rails_helper"

RSpec.describe Customer, type: :model do
  subject { FactoryBot.build(:customer) }
  context "validations" do
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
  end

  context "when attributes are missing" do
    it "returns false on valid?" do
      expect(subject.valid?).to be true
      subject.name = nil
      expect(subject.valid?).to be false
    end
  end

  context "when email has invalid format" do
    it "returns false on valid?" do
      subject.email = "miko@"
      expect(subject.valid?).to be false
      expect(subject.errors.full_messages).to include "Email is invalid"
    end
  end
end