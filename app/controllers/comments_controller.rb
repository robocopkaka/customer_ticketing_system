class CommentsController < ApplicationController
  skip_after_action :refresh_session, only: :index
  prepend_before_action :authenticate_user, only: %i[create index]
  before_action :find_request, only: %i[create index]
  before_action :customer_can_post, only: %i[create]


  def create
    comment = @support_request.comments
                .create!(comment_params)
    json_response(object: comment, status: :created)
  end

  def index
    comments = @support_request.comments.order_asc
    json_response(object: comments)
  end

  private

  def find_request
    @support_request = SupportRequest.find_by!(uid: params[:support_request_id])
  end

  def customer_can_post
    commenter = @user
    return unless commenter && commenter.type == "Customer"

    if @support_request.comments.empty?
      render json: { errors: [{customer: ["is unauthorized"]}] },status: 401
    end
  end

  def comment_params
    params
      .permit(:body)
      .merge(commenter_id: @user.id)
  end
end
