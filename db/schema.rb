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

ActiveRecord::Schema[7.1].define(version: 2024_07_09_010646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.integer "driver_id"
    t.string "home_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_drivers_on_driver_id"
  end

  create_table "rides", force: :cascade do |t|
    t.integer "ride_id"
    t.string "starting_address"
    t.string "destination_address"
    t.decimal "ride_duration", precision: 10, scale: 2
    t.decimal "ride_distance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ride_id"], name: "index_rides_on_ride_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.bigint "driver_id", null: false
    t.decimal "commute_duration", precision: 10, scale: 2
    t.decimal "commute_distance", precision: 10, scale: 2
    t.decimal "total_duration", precision: 10, scale: 2
    t.decimal "total_distance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["ride_id"], name: "index_trips_on_ride_id"
  end

  add_foreign_key "trips", "drivers"
  add_foreign_key "trips", "rides"
end
