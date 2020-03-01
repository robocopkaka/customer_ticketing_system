class AddStatusToSupportRequests < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE support_requests ADD status enum('opened', 'assigned', 'resolved') DEFAULT 'opened';
    SQL
  end

  def down
    remove_column :support_requests, :status
  end
end
