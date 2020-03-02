class SupportRequestSerializer < ActiveModel::Serializer
  attributes :id,
             :subject,
             :description,
             :status,
             :requester_id,
             :assignee_id
  def id
    object.uid
  end
end