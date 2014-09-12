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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140902210605) do

  create_table "actions", :force => true do |t|
    t.string   "subject"
    t.string   "verb"
    t.string   "object"
    t.string   "object_detail"
    t.json     "result"
    t.datetime "occurred_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "api_keys", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "key",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "approved_site_actions", :force => true do |t|
    t.integer  "approved_site_id", :null => false
    t.string   "action_type",      :null => false
    t.string   "url_pattern",      :null => false
    t.string   "css_selector"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "approved_sites", :force => true do |t|
    t.string   "site_name",      :null => false
    t.string   "url",            :null => false
    t.string   "logo_url_small"
    t.string   "logo_url_large"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "course_offerings", :force => true do |t|
    t.integer  "course_id",  :null => false
    t.string   "sis_id"
    t.string   "other_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "course_code"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",                    :null => false
    t.string   "description"
    t.string   "subject_area"
    t.boolean  "high_school_requirement"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "districts", :force => true do |t|
    t.string   "state_id"
    t.string   "nces_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",       :null => false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "phone"
    t.string   "grade_low"
    t.string   "grade_high"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emails", :force => true do |t|
    t.string  "email"
    t.boolean "primary"
    t.integer "user_id"
  end

  create_table "janitor_jobs", :force => true do |t|
    t.string   "job_status"
    t.string   "janitor_type"
    t.string   "job_id"
    t.string   "table_name"
    t.integer  "table_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "raw_messages", :force => true do |t|
    t.integer  "status_id"
    t.string   "api_key",     :null => false
    t.string   "email",       :null => false
    t.string   "action"
    t.string   "event"
    t.string   "url"
    t.text     "html"
    t.datetime "captured_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "state_id"
    t.string   "nces_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",       :null => false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "phone"
    t.string   "grade_low"
    t.string   "grade_high"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sections", :force => true do |t|
    t.string   "section_code"
    t.integer  "course_offering_id", :null => false
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",               :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "sections_users", :force => true do |t|
    t.string  "relationship"
    t.integer "section_id"
    t.integer "user_id"
  end

  create_table "staff_members", :force => true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "staff_member_type", :null => false
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "students", :force => true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "grade_level"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",    :null => false
    t.string   "middle_name"
    t.string   "last_name",     :null => false
    t.string   "gender"
    t.string   "username",      :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.date     "date_of_birth"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
