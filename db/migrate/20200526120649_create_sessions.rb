class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :user_agent
      t.datetime :expires_at
      t.datetime :deleted_at
      # change this from session_user to user after removing STI
      t.string :session_user_id
      t.string :session_user_type
      t.string :uid, null: false

      t.timestamps
    end

    add_index :sessions, :uid, unique: true
    add_index :sessions, [:session_user_id, :session_user_type]
  end
end
