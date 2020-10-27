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

ActiveRecord::Schema.define(version: 2020_06_11_090607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_apps", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "api_key"
    t.string "api_secret"
    t.string "base_url"
    t.string "base_callback_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["api_key"], name: "index_client_apps_on_api_key", unique: true
    t.index ["api_secret"], name: "index_client_apps_on_api_secret", unique: true
    t.index ["identifier"], name: "index_client_apps_on_identifier", unique: true
    t.index ["base_url"], name: "index_client_apps_on_base_url", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "client_app_id", null: false
    t.bigint "user_id", null: false
    t.string "refresh_token"
    t.string "client_ip"
    t.string "user_agent"
    t.datetime "accessed_at"
    t.datetime "revoked_at"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier"
    t.index ["refresh_token"], name: "index_sessions_on_refresh_token", unique: true
    t.index ["identifier"], name: "index_sessions_on_identifier", unique: true
    t.index ["client_app_id"], name: "index_sessions_on_client_app_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
    t.index ["revoked_at"], name: "index_sessions_on_revoked_at"
    t.index ["expires_at"], name: "index_sessions_on_expires_at"
  end

  create_table "user_actions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "session_id"
    t.bigint "client_app_id", null: false
    t.string "action"
    t.json "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_user_actions_on_action"
    t.index ["client_app_id"], name: "index_user_actions_on_client_app_id"
    t.index ["session_id"], name: "index_user_actions_on_session_id"
    t.index ["user_id"], name: "index_user_actions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "client_app_id", null: false
    t.string "identifier"
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.boolean "email_confirmed", default: false
    t.string "magic_login_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_app_id"], name: "index_users_on_client_app_id"
    t.index ["identifier"], name: "index_users_on_identifier", unique: true
    t.index ["email", "client_app_id"], name: "index_users_on_email_and_client_app", unique: true
    t.index ["email_confirmed"], name: "index_users_on_email_confirmed"
    t.index ["magic_login_token"], name: "index_users_on_magic_login_token", unique: true
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "sessions", "client_apps"
  add_foreign_key "users", "client_apps"
  add_foreign_key "user_actions", "client_apps"
  add_foreign_key "user_actions", "sessions"
  add_foreign_key "user_actions", "users"
end
