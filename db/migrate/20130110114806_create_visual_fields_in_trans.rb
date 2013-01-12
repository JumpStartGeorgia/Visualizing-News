class CreateVisualFieldsInTrans < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :visual_file_name, :string
    add_column :visualization_translations, :visual_content_type, :string
    add_column :visualization_translations, :visual_file_size, :integer
    add_column :visualization_translations, :visual_updated_at, :datetime

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
