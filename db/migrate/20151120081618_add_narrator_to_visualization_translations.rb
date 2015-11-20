class AddNarratorToVisualizationTranslations < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :narrator, :string
  end
end
