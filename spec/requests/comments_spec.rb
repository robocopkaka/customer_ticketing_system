require "rails_helper"

RSpec.describe CommentsController, type: :request do
  let(:support_request) { FactoryBot.create(:support_request) }
  let(:customer) { FactoryBot.create(:customer) }
  let(:support_agent) { FactoryBot.create(:support_agent) }
  let(:params) { FactoryBot.attributes_for(:comment) }
  describe "post /support_requests/:support_request_id/comments" do
    describe "customer comments" do
      context "when a support agent has not commented on a request" do
        before do
          post support_request_comments_path(support_request.id),
               headers: authenticated_headers(customer.id),
               params: params
        end
        it "returns an error if the user tries to comment" do
          errors = json["errors"].first
          expect(response).to have_http_status 401
          expect(errors["customer"]).to include "is unauthorized"
          expect(support_request.comments.count).to eq 0
        end
      end

      context "when a support agent has commented on a request" do
        before do
          post support_request_comments_path(support_request.id),
               headers: authenticated_headers(support_agent.id),
               params: params
        end
        it "allows the user to comment on the request" do
          expect do
            post support_request_comments_path(support_request.id),
                 headers: authenticated_headers(customer.id),
                 params: params
          end.to change(support_request.comments, :size).by 1
          comment = json["data"]["comment"]
          expect(response).to have_http_status 201
          expect(comment["body"]).to eq params[:body]
          expect(Comment.all.pluck(:commenter_id)).to include customer.id
        end
      end
    end

    describe "parameters" do
      context "when valid parameters are passed" do
        before do
          post support_request_comments_path(support_request.id),
               headers: authenticated_headers(support_agent.id),
               params: params
        end
        it "saves the comment" do
          comment = json["data"]["comment"]
          expect(response).to have_http_status 201
          expect(comment["body"]).to eq params[:body]
        end
      end

      context "when invalid params are passed" do
        before do
          params.delete(:body)
          post support_request_comments_path(support_request.id),
               headers: authenticated_headers(support_agent.id),
               params: params
        end
        it "returns an error" do
          errors = json["errors"].first
          expect(response).to have_http_status 422
          expect(errors["body"]).to include "can't be blank"
        end
      end
    end
  end

  describe "get /support_requests/:support_request_id/comments" do
    context "when the support request id is valid" do
      before do
        post support_request_comments_path(support_request.id),
             headers: authenticated_headers(support_agent.id),
             params: params
        get support_request_comments_path(support_request.id),
            headers: authenticated_headers(support_agent.id)
      end
      it "returns comments for the request" do
        comments = json["data"]["comments"]
        expect(response).to have_http_status 200
        expect(comments.count).to eq 1
        expect(comments.first["support_request_id"]).to eq support_request.id
      end
    end

    context "when user is not logged in" do
      before do
        post support_request_comments_path(support_request.id),
             headers: authenticated_headers(support_agent.id),
             params: params
      end

      it "returns an error" do
        get support_request_comments_path(support_request.id)
        errors = json["errors"].first
        expect(response).to have_http_status 401
        expect(errors["user"]).to include "is unauthorized"
      end
    end
  end
end