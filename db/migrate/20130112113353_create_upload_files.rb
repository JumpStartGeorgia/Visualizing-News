class CreateUploadFiles < ActiveRecord::Migration
  def change
    create_table :upload_files do |t|
      t.integer :visualization_translation_id
      t.integer :type_id
			t.string :upload_file_name
			t.string :upload_content_type
			t.integer :upload_file_size
			t.datetime :upload_updated_at

      t.timestamps
    end

		add_index :upload_files, [:visualization_translation_id, :type_id], :name => 'idx_upload_type'

		add_column :visualization_translations, :interactive_url, :string
		add_column :visualization_translations, :visual_is_cropped, :boolean, :default => false

    rename_column :visualizations, :visual_file_name, :visual_file_name_old
    rename_column :visualizations, :visual_content_type, :visual_content_type_old
    rename_column :visualizations, :visual_file_size, :visual_file_size_old
    rename_column :visualizations, :visual_updated_at, :visual_updated_at_old

		rename_column :visualizations, :interactive_url, :interactive_url_old
		rename_column :visualizations, :visual_is_cropped, :visual_is_cropped_old
	end
end
