class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commenter_name, :support_request_id, :created_at

  def commenter_type
    User.includes(:support_requests).find_by!(id: object.commenter_id).type
  end

  # has_one :support_agent

  def commenter_name
    object.customer.name.capitalize
  end
end