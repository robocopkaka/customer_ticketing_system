class AddUidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string, null: false
  end
end
