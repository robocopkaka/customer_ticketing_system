class AddPriorityToSupportRequests < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE support_requests ADD priority enum("low", "normal", "high") DEFAULT "normal";
    SQL
  end

  def down
    remove_column :support_requests, :priority
  end
end
