require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validation" do
    it { should validate_presence_of :body }
  end
end
