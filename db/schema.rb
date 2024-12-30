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

ActiveRecord::Schema[8.0].define(version: 2024_12_29_210252) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status", default: "waiting", null: false
    t.integer "pot"
    t.integer "max_players"
    t.string "name"
    t.jsonb "cards", default: []
    t.jsonb "comunity_cards", default: []
    t.jsonb "available_cards", default: []
    t.integer "phase", default: 0
    t.boolean "is_showdown", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_games", force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "game_id", null: false
    t.integer "chips"
    t.string "status"
    t.jsonb "hand"
    t.integer "last_position"
    t.integer "bet"
    t.string "last_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_player_games_on_game_id"
    t.index ["player_id"], name: "index_player_games_on_player_id"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", limit: 64, null: false
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "player_games", "games"
  add_foreign_key "player_games", "players"
end
