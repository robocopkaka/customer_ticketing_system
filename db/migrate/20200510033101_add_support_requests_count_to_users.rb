class AddSupportRequestsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :support_requests_count, :integer, null: false, default: 0
  end
end
