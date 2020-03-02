class AddUidToSupportRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :support_requests, :uid, :string, null: false
  end
end
