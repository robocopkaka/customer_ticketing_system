class CommentsController < ApplicationController
  before_action :authenticate_resources, only: %i[create]
  before_action :find_request, only: %i[create index]
  before_action :customer_can_post, only: %i[create]
  before_action :is_logged_in?, only: %i[create index]


  def create
    comment = @support_request.comments
                .create!(comment_params)
    json_response(comment, "", :created)
  end

  def index
    comments = @support_request.comments.order_asc
    json_response(comments, "")
  end

  private

  def find_request
    @support_request = SupportRequest.find_by!(uid: params[:support_request_id])
  end

  def customer_can_post
    commenter = authenticate_resources
    return unless commenter && commenter.type == "Customer"

    if @support_request.comments.empty?
      render json: { errors: [{customer: ["is unauthorized"]}] },status: 401
    end
  end

  # run authentications for both customers and support_agents
  def authenticate_resources
    authenticate_for(SupportAgent) || authenticate_for(Customer) || authenticate_for(Admin)
  end

  def is_logged_in?
    return unless authenticate_resources.nil?

    render json: { errors: [{user: ["is unauthorized"]}] },status: 401
  end

  def comment_params
    params
      .permit(:body)
      .merge(commenter_id: authenticate_resources.id)
  end
end
