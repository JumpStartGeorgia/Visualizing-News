class AddVisualText < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :visualization_text, :text
  end
end
