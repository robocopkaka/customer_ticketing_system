class AddUidToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :uid, :string
  end
end
