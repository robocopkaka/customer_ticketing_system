class SupportRequestSerializer < ActiveModel::Serializer
  attributes :id,
             :subject,
             :description,
             :status,
             :requester_id,
             :assignee_id
end