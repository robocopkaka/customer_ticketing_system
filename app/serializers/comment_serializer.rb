class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commenter_name, :support_request_id, :created_at

  # has_one :support_agent

  def commenter_name
    object.customer.name.capitalize
  end
end