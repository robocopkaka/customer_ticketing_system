require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "validations" do
    it { should belong_to :session_user }
  end
end
