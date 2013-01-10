class CreateVisualFieldsInTrans < ActiveRecord::Migration
  def up
    add_column :visualization_translations, :visual_file_name, :string
    add_column :visualization_translations, :visual_content_type, :string
    add_column :visualization_translations, :visual_file_size, :integer
    add_column :visualization_translations, :visual_updated_at, :datetime

		add_column :visualization_translations, :interactive_url, :string
		add_column :visualization_translations, :visual_is_cropped, :boolean, :default => false
  end

  def down
    remove_column :visualization_translations, :visual_file_name
    remove_column :visualization_translations, :visual_content_type
    remove_column :visualization_translations, :visual_file_size
    remove_column :visualization_translations, :visual_updated_at

		remove_column :visualization_translations, :interactive_url
		remove_column :visualization_translations, :visual_is_cropped
  end
end
