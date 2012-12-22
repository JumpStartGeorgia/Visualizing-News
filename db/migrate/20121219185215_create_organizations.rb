class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.timestamps
    end

    add_column :organizations, :logo_file_name, :string
    add_column :organizations, :logo_content_type, :string
    add_column :organizations, :logo_file_size, :integer
    add_column :organizations, :logo_updated_at, :datetime

		Organization.create_translation_table! :name => :string
  end

	def self.down
		Organization.drop_translation_table!
		remove_attachment :organizations, :logo
		drop_table :organizations
	end
end
