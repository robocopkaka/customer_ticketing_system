class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commenter_id, :support_request_id, :created_at

  # keep till later
  def commenter_type
    User.includes(:support_requests).find_by!(id: object.commenter_id).type
  end
end