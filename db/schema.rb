# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150929230544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "phone_number"
    t.string   "password_digest"
    t.string   "car_make"
    t.string   "car_model"
    t.integer  "car_capacity"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "riders", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "phone_number"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "rides", force: :cascade do |t|
    t.string   "pickup_location"
    t.string   "dropoff_location"
    t.integer  "number_of_passengers"
    t.string   "status",               default: "active"
    t.datetime "requested_time"
    t.datetime "accepted_time"
    t.datetime "pickup_time"
    t.datetime "dropoff_time"
    t.integer  "rider_id"
    t.integer  "driver_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "rides", ["driver_id"], name: "index_rides_on_driver_id", using: :btree
  add_index "rides", ["rider_id"], name: "index_rides_on_rider_id", using: :btree

  add_foreign_key "rides", "drivers"
  add_foreign_key "rides", "riders"
end
