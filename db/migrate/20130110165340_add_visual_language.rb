class AddVisualLanguage < ActiveRecord::Migration
  def change
    add_column :visualizations, :languages, :string
  end
end
