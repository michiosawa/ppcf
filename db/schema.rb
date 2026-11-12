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

ActiveRecord::Schema[8.1].define(version: 2026_10_12_100240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "address"
    t.string "owner"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "contact"
    t.text "comment"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "workdays", force: :cascade do |t|
    t.bigint "worker_id", null: false
    t.bigint "workplace_id", null: false
    t.datetime "checkin"
    t.datetime "checkout"
    t.jsonb "healthcheck"
    t.decimal "overtime"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_id"], name: "index_workdays_on_worker_id"
    t.index ["workplace_id"], name: "index_workdays_on_workplace_id"
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.string "tel"
    t.integer "last"
    t.string "access_token"
    t.jsonb "etc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_workers_on_access_token", unique: true
    t.index ["company_id"], name: "index_workers_on_company_id"
  end

  create_table "workmonths", force: :cascade do |t|
    t.integer "month"
    t.bigint "workplace_id", null: false
    t.text "entries"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workplace_id"], name: "index_workmonths_on_workplace_id"
  end

  create_table "workplaces", force: :cascade do |t|
    t.string "title"
    t.integer "manager"
    t.text "address"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "workdays", "workers"
  add_foreign_key "workdays", "workplaces"
  add_foreign_key "workers", "companies"
  add_foreign_key "workmonths", "workplaces"
end
