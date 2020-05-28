# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_26_120649) do

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "body"
    t.string "commenter_id"
    t.string "support_request_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "user_agent"
    t.datetime "expires_at", default: "2020-05-29 08:23:55"
    t.datetime "deleted_at"
    t.string "session_user_id"
    t.string "session_user_type"
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_user_id", "session_user_type"], name: "index_sessions_on_session_user_id_and_session_user_type"
    t.index ["uid"], name: "index_sessions_on_uid", unique: true
  end

  create_table "support_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "subject", null: false
    t.text "description", null: false
    t.datetime "resolved_at"
    t.string "requester_id"
    t.string "assignee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.column "status", "enum('opened','assigned','resolved')", default: "opened"
    t.string "uid", null: false
    t.column "priority", "enum('low','normal','high')", default: "normal"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.boolean "admin", default: false
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "uid", null: false
    t.integer "support_requests_count", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
