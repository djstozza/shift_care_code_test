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

ActiveRecord::Schema.define(version: 2021_10_27_022102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.citext "address_line_1"
    t.citext "address_line_2"
    t.citext "suburb"
    t.citext "post_code"
    t.citext "state"
    t.citext "country"
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "admins", force: :cascade do |t|
    t.citext "email", null: false
    t.string "encrypted_password", null: false
    t.citext "first_name", null: false
    t.citext "last_name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.citext "email", null: false
    t.citext "first_name", null: false
    t.citext "last_name", null: false
    t.date "date_of_birth", null: false
    t.string "private_note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.bigint "client_id"
    t.boolean "done", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_jobs_on_client_id"
  end

  create_table "jobs_plumbers", id: false, force: :cascade do |t|
    t.bigint "plumber_id", null: false
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_jobs_plumbers_on_job_id"
    t.index ["plumber_id"], name: "index_jobs_plumbers_on_plumber_id"
  end

  create_table "plumbers", force: :cascade do |t|
    t.citext "email", null: false
    t.citext "first_name", null: false
    t.citext "last_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_plumbers_on_email", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "plumber_id"
    t.citext "make", null: false
    t.citext "model", null: false
    t.citext "other_make"
    t.integer "year", null: false
    t.citext "number_plate", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number_plate"], name: "index_vehicles_on_number_plate", unique: true
    t.index ["plumber_id"], name: "index_vehicles_on_plumber_id"
  end

end
