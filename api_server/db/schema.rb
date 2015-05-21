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

ActiveRecord::Schema.define(version: 20150513011355) do

  create_table "message_lists", force: :cascade do |t|
    t.integer "engineer", limit: 4, null: false
    t.integer "girl",     limit: 4, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body",            limit: 255, null: false
    t.integer  "user_id",         limit: 4,   null: false
    t.integer  "message_list_id", limit: 4,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "messages", ["body"], name: "idx_body", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "description", limit: 65535
    t.integer  "money",       limit: 4
    t.integer  "age",         limit: 4
    t.string   "image_url",   limit: 255
    t.string   "profile_url", limit: 255
    t.boolean  "is_engineer", limit: 1,     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "users", ["image_url"], name: "index_users_on_image_url", unique: true, using: :btree
  add_index "users", ["profile_url"], name: "index_users_on_profile_url", unique: true, using: :btree

end
