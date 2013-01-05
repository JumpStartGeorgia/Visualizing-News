class AddPermalinkToVisualizationTranslation < ActiveRecord::Migration
  def self.up
    add_column :visualization_translations, :permalink, :string
    add_index :visualization_translations, :permalink
  end
  def self.down
    remove_column :visualization_translations, :permalink
  end
end