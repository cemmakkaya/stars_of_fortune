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

ActiveRecord::Schema[7.2].define(version: 2024_09_25_221651) do
  create_table "game_histories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.integer "amount"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_histories_on_game_id"
    t.index ["user_id"], name: "index_game_histories_on_user_id"
  end

  create_table "game_participations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.integer "selected_card"
    t.integer "bet_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_participations_on_game_id"
    t.index ["user_id"], name: "index_game_participations_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "status"
    t.integer "winning_card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_games_on_group_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "username"
    t.integer "c_bucks", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_encrypted_password"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_histories", "games"
  add_foreign_key "game_histories", "users"
  add_foreign_key "game_participations", "games"
  add_foreign_key "game_participations", "users"
  add_foreign_key "games", "groups"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
end
