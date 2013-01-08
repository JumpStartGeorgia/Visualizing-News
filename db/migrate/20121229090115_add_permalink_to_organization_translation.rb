class AddPermalinkToOrganizationTranslation < ActiveRecord::Migration
  def self.up
    add_column :organization_translations, :permalink, :string
    add_index :organization_translations, :permalink
  end
  def self.down
    remove_column :organization_translations, :permalink
  end
end