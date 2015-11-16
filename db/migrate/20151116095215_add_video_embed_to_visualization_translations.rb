class AddVideoEmbedToVisualizationTranslations < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :video_embed, :string
  end
end
