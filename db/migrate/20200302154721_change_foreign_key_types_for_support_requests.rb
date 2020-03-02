class ChangeForeignKeyTypesForSupportRequests < ActiveRecord::Migration[6.0]
  def up
    change_column :support_requests, :requester_id, :string
    change_column :support_requests, :assignee_id, :string
  end

  def down
    change_column :support_requests, :requester_id, :integer
    change_column :support_requests, :assignee_id, :integer
  end
end
