# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_03_171419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.integer "player_id_1"
    t.integer "player_id_2"
    t.integer "player1_set_1"
    t.integer "player1_set_2"
    t.integer "player1_set_3"
    t.integer "player2_set_1"
    t.integer "player2_set_2"
    t.integer "player2_set_3"
    t.datetime "start_time"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "teaser"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "points"
    t.integer "participations"
    t.integer "self_assessment"
    t.integer "tournament_experience"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "best_rank"
    t.integer "wins"
    t.integer "losses"
    t.string "main_characters", default: [], array: true
    t.string "gender"
    t.integer "birth_year"
    t.string "name"
    t.string "surname"
    t.string "patronymic"
    t.string "photo"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.string "location"
    t.text "description"
    t.float "registration_fee"
    t.integer "total_seats"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "started"
    t.boolean "finished"
    t.bigint "challonge_tournament_id"
    t.string "ranking_string"
    t.boolean "setup"
    t.datetime "registration_deadline"
    t.string "host_username"
    t.string "waiting_list", default: [], array: true
    t.string "subtype"
    t.string "city"
    t.datetime "end_date"
    t.string "external_registration_link"
    t.integer "total_needed_game_stations"
    t.integer "min_needed_registrations"
    t.boolean "is_registration_allowed", default: true
    t.integer "number_of_pools", default: 0
    t.string "image_link"
    t.string "image_height"
    t.string "image_width"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "is_admin"
    t.string "challonge_username"
    t.string "challonge_api_key"
    t.boolean "is_super_admin"
    t.string "full_name"
    t.string "mobile_number"
    t.string "area_of_responsibility"
    t.boolean "is_club_member", default: false
    t.boolean "wants_major_email", default: true
    t.boolean "wants_weekly_email", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
