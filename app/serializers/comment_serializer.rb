class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commenter_name, :support_request_id, :created_at, :commenter_role

  # has_one :support_agent

  def commenter_name
    object.support_agent.name.capitalize
  end

  def commenter_role
    object.customer.type
  end
end