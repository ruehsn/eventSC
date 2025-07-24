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

ActiveRecord::Schema[8.0].define(version: 2025_05_06_120000) do
  create_table "advisors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_option_vehicles", force: :cascade do |t|
    t.integer "event_option_id"
    t.integer "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_options", force: :cascade do |t|
    t.text "description"
    t.decimal "cost"
    t.integer "event_id"
    t.boolean "office_holds_cash"
    t.boolean "transportation_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.text "survey_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "living_areas", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_event_options", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "event_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_option_id"], name: "index_student_event_options_on_event_option_id"
    t.index ["student_id"], name: "index_student_event_options_on_student_id"
  end

  create_table "student_event_options", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "event_id", null: false
    t.integer "event_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_student_event_options_on_event_id"
    t.index ["event_option_id"], name: "index_student_event_options_on_event_option_id"
    t.index ["student_id"], name: "index_student_event_options_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "short_name"
    t.string "first_name"
    t.string "last_name"
    t.string "notes_url"
    t.integer "living_area_id", null: false
    t.integer "advisor_id", null: false
    t.integer "year"
    t.string "gender"
    t.string "major"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "student_life_holds_cash", default: false
    t.index ["advisor_id"], name: "index_students_on_advisor_id"
    t.index ["living_area_id"], name: "index_students_on_living_area_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.text "name"
    t.integer "passenger_capacity"
    t.boolean "working"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "student_event_options", "event_options"
  add_foreign_key "student_event_options", "students"
  add_foreign_key "student_event_options", "event_options"
  add_foreign_key "student_event_options", "events"
  add_foreign_key "student_event_options", "students"
  add_foreign_key "students", "advisors"
  add_foreign_key "students", "living_areas"
end
