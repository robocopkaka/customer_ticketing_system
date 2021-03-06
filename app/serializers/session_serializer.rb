class SessionSerializer < ActiveModel::Serializer
  attributes :id,
             :active,
             :expires_at,
             :deleted,
             :deleted_at,
             :role,
             :user_id,
             :user_agent

  def active
    object.expires_at > Time.current && object.deleted_at.nil?
  end

  def role
    object.session_user.class.to_s.underscore.humanize
  end

  def user_id
    object.session_user_id
  end

  def deleted
    object.deleted_at.present?
  end

  def deleted_at
    object.deleted_at&.iso8601
  end

  def expires_at
    object.expires_at&.iso8601
  end
end
