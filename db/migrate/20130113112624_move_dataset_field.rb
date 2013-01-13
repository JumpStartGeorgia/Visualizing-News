class MoveDatasetField < ActiveRecord::Migration
  def change

    create_table :dataset_files do |t|
      t.integer :visualization_translation_id
			t.string :file_file_name
			t.string :file_content_type
			t.integer :file_file_size
			t.datetime :file_updated_at

      t.timestamps
    end
		add_index :dataset_files, :visualization_translation_id


    rename_column :visualizations, :dataset_file_name, :dataset_file_name_old
    rename_column :visualizations, :dataset_content_type, :dataset_content_type_old
    rename_column :visualizations, :dataset_file_size, :dataset_file_size_old
    rename_column :visualizations, :dataset_updated_at, :dataset_updated_at_old
  end

end
