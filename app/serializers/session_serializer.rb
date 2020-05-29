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
    object.expires_at > Time.current
  end

  def role
    object.session_user.class.to_s.capitalize
  end

  def user_id
    object.session_user_id
  end

  def deleted
    object.deleted_at.present?
  end
end
