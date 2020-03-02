class ChangeForeignKeyTypesInComments < ActiveRecord::Migration[6.0]
  def up
    change_column :comments, :commenter_id, :string
    change_column :comments, :support_request_id, :string
  end

  def down
    change_column :comments, :commenter_id, :integer
    change_column :comments, :support_request_id, :integer
  end
end
