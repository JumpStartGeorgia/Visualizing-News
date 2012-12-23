class ChangeStoryToVisual2 < ActiveRecord::Migration
  def up

    rename_column :visualizations, :story_type_id, :visualization_type_id
    add_index :visualizations, :visualization_type_id
    add_index "visualizations", ["organization_id"]

    rename_column :visualization_categories, :story_id, :visualization_id
    add_index :visualization_categories, :visualization_id
    add_index "visualization_categories", ["category_id"]
    
    rename_column :visualization_translations, :story_id, :visualization_id
    add_index :visualization_translations, :visualization_id
    add_index "visualization_translations", ["locale"]
    
    rename_column :visualization_type_translations, :story_type_id, :visualization_type_id
    add_index :visualization_type_translations, :visualization_type_id
    add_index "visualization_type_translations", ["locale"]
    
    
  end

  def down
    remove__index :visualizations, :visualization_type_id
    remove_index "visualizations", ["organization_id"]
    rename_column :visualizations, :visualization_type_id, :story_type_id

    remove_index :visualization_categories, :visualization_id
    remove_index "visualization_categories", ["category_id"]
    rename_column :visualization_categories, :visualization_id, :story_id
    
    remove_index :visualization_translations, :visualization_id
    remove_index "visualization_translations", ["locale"]
    rename_column :visualization_translations, :visualization_id, :story_id
    
    remove_index :visualization_type_translations, :visualization_type_id
    remove_index "visualization_type_translations", ["locale"]
    rename_column :visualization_type_translations, :visualization_type_id, :story_type_id

  end
end
