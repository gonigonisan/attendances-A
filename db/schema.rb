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

ActiveRecord::Schema.define(version: 20240104202147) do

  create_table "applies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "banksmen"
    t.string "next_day"
    t.string "business_processing"
    t.datetime "overtime_finished_at"
    t.string "indicater_check"
    t.datetime "scheduled_end_time"
    t.string "overtime_work"
    t.datetime "overtime_worked_on"
    t.string "instructor_test"
    t.string "indicater_reply_month"
    t.string "indicater_check_month"
    t.date "month_approval"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.text "information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "code"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "uid"
    t.string "employee_number"
    t.datetime "basic_work_time", default: "2023-10-29 23:00:00"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.string "affiliation"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
