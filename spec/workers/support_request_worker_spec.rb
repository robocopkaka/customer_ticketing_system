require "rails_helper"
require "sidekiq/testing"
require "sidekiq/extensions/action_mailer"

RSpec.describe SupportRequestWorker, type: :worker do
  let(:support_agent) { FactoryBot.create(:support_agent) }
  let!(:support_requests) { FactoryBot.create_list(:support_request, 5, assignee_id: support_agent.id) }
  before { ActionMailer::Base.deliveries.clear }

  context "when the worker is called" do
    it "pushes a job onto the queue" do
      Sidekiq::Testing.fake!
      expect do
        SupportRequestWorker.perform_async(support_agent.id)
      end.to change(SupportRequestWorker.jobs, :size).by 1
    end

    it "sends a mail with requests out" do
      Sidekiq::Testing.inline! do
        3.times { SupportRequestWorker.perform_async(support_agent.id) }
        expect(ActionMailer::Base.deliveries.size).to eq 3
      end
    end
  end
end