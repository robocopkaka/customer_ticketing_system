class SupportRequestSerializer < ActiveModel::Serializer
  attributes :id,
             :subject,
             :description,
             :status,
             :requester_id,
             :assignee_id,
             :created_at,
             # :resolved_count
  def id
    object.uid
  end

  def status
    object.status.capitalize
  end

  def resolved_count
    SupportRequest.where(status: 'resolved')
  end
end