class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.boolean :active
      t.string :user_agent
      t.datetime :expires_at
      t.datetime :deleted_at
      t.references :user, null: false, foreign_key: true
      t.string :uid, null: false

      t.timestamps
    end

    add_index :sessions, :uid, unique: true
  end
end
