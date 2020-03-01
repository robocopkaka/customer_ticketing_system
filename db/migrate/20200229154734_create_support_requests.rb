class CreateSupportRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :support_requests do |t|
      t.string :subject, null: false
      t.text :description, null: false
      t.datetime :resolved_at
      t.integer :requester_id
      t.integer :assignee_id

      t.timestamps
    end
  end
end
