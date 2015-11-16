class AddVideoUrlToVisualizationTranslations < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :video_url, :string
  end
end
