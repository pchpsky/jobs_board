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

ActiveRecord::Schema[7.0].define(version: 2023_08_20_053932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_application_events", force: :cascade do |t|
    t.string "type"
    t.bigint "job_application_id", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_application_id"], name: "index_job_application_events_on_job_application_id"
    t.index ["type"], name: "index_job_application_events_on_type"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "candidate_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
  end

  create_table "job_events", force: :cascade do |t|
    t.string "type"
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_events_on_job_id"
    t.index ["type"], name: "index_job_events_on_type"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "job_application_events", "job_applications"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_events", "jobs"
end
