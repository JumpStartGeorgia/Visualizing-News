class RemoveVizType < ActiveRecord::Migration
  def up
    remove_index "visualization_type_translations", ["locale"]
    remove_index "visualization_type_translations", ["visualization_type_id"]
		drop_table :visualization_type_translations
		drop_table :visualization_types
  end

  def down
    create_table "visualization_type_translations", :force => true do |t|
      t.integer  "visualization_type_id"
      t.string   "locale"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "visualization_type_translations", ["locale"], :name => "index_visualization_type_translations_on_locale"
    add_index "visualization_type_translations", ["visualization_type_id"], :name => "index_visualization_type_translations_on_visualization_type_id"

    create_table "visualization_types", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
