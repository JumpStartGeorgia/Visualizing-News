class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.timestamps
    end

    add_column :categories, :icon_file_name, :string
    add_column :categories, :icon_content_type, :string
    add_column :categories, :icon_file_size, :integer
    add_column :categories, :icon_updated_at, :datetime

		Category.create_translation_table! :name => :string
  end

	def self.down
		Category.drop_translation_table!
		drop_table :categories
	end
end
