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

ActiveRecord::Schema.define(:version => 20121219185213) do

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_translations", ["locale"], :name => "index_page_translations_on_locale"
  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.datetime "published_date"
    t.boolean  "published",            :default => false
    t.integer  "story_type_id"
    t.string   "data_source_url"
    t.string   "individual_votes"
    t.integer  "overall_votes",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dataset_file_name"
    t.string   "dataset_content_type"
    t.integer  "dataset_file_size"
    t.datetime "dataset_updated_at"
    t.string   "visual_file_name"
    t.string   "visual_content_type"
    t.integer  "visual_file_size"
    t.datetime "visual_updated_at"
  end

  create_table "story_categories", :force => true do |t|
    t.integer  "story_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_categories", ["category_id"], :name => "index_story_categories_on_category_id"
  add_index "story_categories", ["story_id"], :name => "index_story_categories_on_story_id"

  create_table "story_translations", :force => true do |t|
    t.integer  "story_id"
    t.string   "locale"
    t.string   "title"
    t.text     "explanation"
    t.string   "reporter"
    t.string   "designer"
    t.string   "data_source_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_translations", ["locale"], :name => "index_story_translations_on_locale"
  add_index "story_translations", ["story_id"], :name => "index_story_translations_on_story_id"

  create_table "story_type_translations", :force => true do |t|
    t.integer  "story_type_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_type_translations", ["locale"], :name => "index_story_type_translations_on_locale"
  add_index "story_type_translations", ["story_type_id"], :name => "index_story_type_translations_on_story_type_id"

  create_table "story_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "role",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "avatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "voter_ips", :force => true do |t|
    t.string   "ip",           :limit => 50, :default => ""
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "voter_ips", ["ip", "votable_type", "votable_id", "status"], :name => "idx_voter_ip"

end
