# frozen_string_literal: true

# Tests for assign_requests_worker

require "rails_helper"
require "sidekiq/testing"
require "sidekiq/extensions/action_mailer"

RSpec.describe AssignRequestsWorker, type: :worker do
  let!(:support_requests) { create_list(:support_request, 3) }
  let!(:support_agents) { create_list(:support_agent, 3) }
  let!(:admin) { create(:admin) }
  before { ActionMailer::Base.deliveries.clear }

  describe "#perform" do
    context "when worker is called" do
      it "pushes a job onto the queue" do
        Sidekiq::Testing.fake!
        expect do
          AssignRequestsWorker.perform_async(support_requests.first[:id])
        end.to change(AssignRequestsWorker.jobs, :size).by 1
      end

      it "sends out assigns the request" do
        Sidekiq::Testing.inline! do
          request = AssignRequestsWorker.new.perform(support_requests.first[:id])
          expect(support_agents.pluck(:uid)).to include request.assignee_id
        end
      end
    end

    context "when there's no available agent" do
      before do
        support_agents.each { |agent| agent.update!(support_requests_count: 5) }
      end
      it "sends out a mail" do
        mail = AssignRequestsWorker.new.perform(support_requests.first[:id])
        expect(mail).to be_a_kind_of ActionMailer::MailDeliveryJob
      end
    end
  end
end