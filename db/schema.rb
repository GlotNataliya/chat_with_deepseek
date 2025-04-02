# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_01_165548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.string "deepseek_model_role"
    t.text "content"
    t.jsonb "result"
    t.text "reasoning_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "add_assistant", default: false
    t.text "assistant_prompt"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "deepseek_model_name"
    t.float "temperature"
    t.integer "max_tokens"
    t.float "top_p"
    t.boolean "stream"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_settings_on_message_id"
  end

  add_foreign_key "messages", "chats"
  add_foreign_key "settings", "messages"
end
