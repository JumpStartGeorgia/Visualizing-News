class MoveDatasetField < ActiveRecord::Migration
  def change
    rename_column :visualizations, :dataset_file_name, :dataset_file_name_old
    rename_column :visualizations, :dataset_content_type, :dataset_content_type_old
    rename_column :visualizations, :dataset_file_size, :dataset_file_size_old
    rename_column :visualizations, :dataset_updated_at, :dataset_updated_at_old
  end

end
