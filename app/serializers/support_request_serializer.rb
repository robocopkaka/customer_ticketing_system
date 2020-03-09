class SupportRequestSerializer < ActiveModel::Serializer
  attributes :id,
             :subject,
             :description,
             :status,
             :requester_id,
             :assignee_id,
             :created_at,
             :resolved_at
  def id
    object.uid
  end

  def status
    object.status.capitalize
  end
end