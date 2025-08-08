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

ActiveRecord::Schema[8.0].define(version: 2025_08_08_035027) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advisors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
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
    t.time "leave_time"
    t.time "return_time"
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

  create_table "magic_link_tokens", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.datetime "expires_at"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "student_life_holds_cash", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_id"
    t.string "parent_email"
    t.index ["advisor_id"], name: "index_students_on_advisor_id"
    t.index ["living_area_id"], name: "index_students_on_living_area_id"
    t.index ["short_name"], name: "index_students_on_short_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "student_event_options", "event_options"
  add_foreign_key "student_event_options", "events"
  add_foreign_key "student_event_options", "students"
  add_foreign_key "students", "advisors"
  add_foreign_key "students", "living_areas"
end
