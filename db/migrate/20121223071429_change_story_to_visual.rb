class ChangeStoryToVisual < ActiveRecord::Migration
  def up

    remove_index "stories", ["organization_id"]

    remove_index "story_categories", ["category_id"]
    remove_index :story_categories, :story_id
    
    remove_index "story_translations", ["locale"]
    remove_index :story_translations, :story_id
    
    remove_index "story_type_translations", ["locale"]
    remove_index :story_type_translations, :story_type_id

    rename_table(:stories, :visualizations)
    rename_table(:story_categories, :visualization_categories)
    rename_table(:story_translations, :visualization_translations)
    rename_table(:story_types, :visualization_types)
    rename_table(:story_type_translations, :visualization_type_translations)
    
    
  end

  def down
    rename_table(:visualizations, :stories)
    rename_table(:visualization_categories, :story_categories)
    rename_table(:visualization_translations, :story_translations)
    rename_table(:visualization_types, :story_types)
    rename_table(:visualization_type_translations, :story_type_translations)

    add_index "stories", ["organization_id"]

    add_index "story_categories", ["category_id"]
    add_index :story_categories, :story_id
    
    add_index "story_translations", ["locale"]
    add_index :story_translations, :story_id
    
    add_index "story_type_translations", ["locale"]
    add_index :story_type_translations, :story_type_id
  end
end
