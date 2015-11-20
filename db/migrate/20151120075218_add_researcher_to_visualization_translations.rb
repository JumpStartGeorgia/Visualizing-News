class AddResearcherToVisualizationTranslations < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :researcher, :string
  end
end
