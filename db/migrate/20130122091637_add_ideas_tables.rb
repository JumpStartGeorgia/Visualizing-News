class AddIdeasTables < ActiveRecord::Migration
  def change
    create_table "idea_categories", :force => true do |t|
      t.integer  "idea_id"
      t.integer  "category_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "idea_categories", ["category_id"], :name => "index_idea_categories_on_category_id"
    add_index "idea_categories", ["idea_id"], :name => "index_idea_categories_on_idea_id"

    create_table "idea_inappropriate_reports", :force => true do |t|
      t.integer  "idea_id"
      t.integer  "user_id"
      t.string   "reason"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "idea_inappropriate_reports", ["idea_id"], :name => "index_idea_inappropriate_reports_on_idea_id"
    add_index "idea_inappropriate_reports", ["user_id"], :name => "index_idea_inappropriate_reports_on_user_id"

    create_table "idea_progresses", :force => true do |t|
      t.integer  "idea_id"
      t.integer  "organization_id"
      t.date     "progress_date"
      t.text     "explaination"
      t.boolean  "is_completed",    :default => false
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "idea_status_id"
      t.boolean  "is_private",      :default => false
    end

    add_index "idea_progresses", ["idea_id", "organization_id"], :name => "idea_prog_idea_org"
    add_index "idea_progresses", ["is_completed"], :name => "index_idea_progresses_on_is_completed"
    add_index "idea_progresses", ["is_private"], :name => "index_idea_progresses_on_is_private"
    add_index "idea_progresses", ["progress_date"], :name => "index_idea_progresses_on_progress_date"

    create_table "idea_status_translations", :force => true do |t|
      t.integer  "idea_status_id"
      t.string   "locale"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "idea_status_translations", ["idea_status_id"], :name => "index_idea_status_translations_on_idea_status_id"
    add_index "idea_status_translations", ["locale"], :name => "index_idea_status_translations_on_locale"

    create_table "idea_statuses", :force => true do |t|
      t.integer  "sort",         :default => 1
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_published", :default => false
    end

    add_index "idea_statuses", ["sort"], :name => "index_idea_statuses_on_sort"

    create_table "ideas", :force => true do |t|
      t.integer  "user_id"
      t.text     "explaination"
      t.string   "individual_votes"
      t.integer  "overall_votes",     :default => 0
      t.boolean  "is_inappropriate",  :default => false
      t.boolean  "is_duplicate",      :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "is_private",        :default => false
      t.integer  "current_status_id"
    end

    add_index "ideas", ["is_inappropriate", "is_duplicate"], :name => "idea_must_hide"
    add_index "ideas", ["is_private"], :name => "index_ideas_on_is_private"
    add_index "ideas", ["overall_votes"], :name => "index_ideas_on_overall_votes"
    add_index "ideas", ["user_id"], :name => "index_ideas_on_user_id"


  end

end
