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

ActiveRecord::Schema[7.1].define(version: 2024_07_10_040009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", id: :string, force: :cascade do |t|
    t.string "home_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_drivers_on_id", unique: true
  end

  create_table "rides", id: :string, force: :cascade do |t|
    t.string "pickup_address", null: false
    t.string "destination_address", null: false
    t.decimal "ride_minutes", precision: 10, scale: 2, null: false
    t.decimal "ride_miles", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_rides_on_id", unique: true
  end

  create_table "trips", id: :string, force: :cascade do |t|
    t.string "driver_id", null: false
    t.string "ride_id", null: false
    t.decimal "commute_minutes", precision: 10, scale: 2
    t.decimal "commute_miles", precision: 10, scale: 2
    t.decimal "total_minutes", precision: 10, scale: 2
    t.decimal "total_hours", precision: 10, scale: 2
    t.decimal "total_miles", precision: 10, scale: 2
    t.decimal "earnings", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_trips_on_id", unique: true
  end

  add_foreign_key "trips", "drivers"
  add_foreign_key "trips", "rides"
end
