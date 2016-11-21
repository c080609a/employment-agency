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

ActiveRecord::Schema.define(version: 20161120203841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "contacts"
    t.boolean  "is_active",  default: false
    t.integer  "salary"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills_employees", primary_key: ["employee_id", "skill"], force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string  "skill",       null: false
    t.index ["employee_id"], name: "index_skills_employees_on_employee_id", using: :btree
  end

  create_table "skills_vacancies", primary_key: ["vacancy_id", "skill"], force: :cascade do |t|
    t.integer "vacancy_id", null: false
    t.string  "skill",      null: false
    t.index ["vacancy_id"], name: "index_skills_vacancies_on_vacancy_id", using: :btree
  end

  create_table "vacancies", force: :cascade do |t|
    t.string   "title"
    t.date     "expiry_date"
    t.integer  "salary"
    t.string   "contacts"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
