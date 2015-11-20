class AddProducerDirectorWriterDesignerAnimatorAndSoundMusicToVisualizationTranslations < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :producer, :string
    add_column :visualization_translations, :director, :string
    add_column :visualization_translations, :writer, :string
    add_column :visualization_translations, :designer_animator, :string
    add_column :visualization_translations, :sound_music, :string
  end
end
