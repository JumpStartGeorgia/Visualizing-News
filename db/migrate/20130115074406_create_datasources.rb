class CreateDatasources < ActiveRecord::Migration
  def change
    create_table :datasources do |t|
      t.integer :visualization_translation_id
      t.string :name
      t.string :url

      t.timestamps
    end
    add_index :datasources, :visualization_translation_id

    rename_column :visualization_translations, :data_source_name, :data_source_name_old
    rename_column :visualization_translations, :data_source_url, :data_source_url_old
  end
end
