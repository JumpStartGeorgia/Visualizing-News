class AddDatasetFile < ActiveRecord::Migration
  def up
    add_column :stories, :dataset_file_name, :string
    add_column :stories, :dataset_content_type, :string
    add_column :stories, :dataset_file_size, :integer
    add_column :stories, :dataset_updated_at, :datetime
  end

  def down
    remove_column :stories, :dataset_file_name
    remove_column :stories, :dataset_content_type
    remove_column :stories, :dataset_file_size
    remove_column :stories, :dataset_updated_at
  end
end
