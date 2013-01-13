class RenameUploadFiles < ActiveRecord::Migration
  def change
		remove_index :upload_files, :name => 'idx_upload_type'
		remove_column :upload_files, :type_id
    rename_column :upload_files, :upload_file_name, :file_file_name
    rename_column :upload_files, :upload_content_type, :file_content_type
    rename_column :upload_files, :upload_file_size, :file_file_size
    rename_column :upload_files, :upload_updated_at, :file_updated_at

		rename_table :upload_files, :image_files

		add_index :image_files, :visualization_translation_id

  end

end
