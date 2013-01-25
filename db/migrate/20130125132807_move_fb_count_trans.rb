class MoveFbCountTrans < ActiveRecord::Migration
  def change
    add_column :visualization_translations, :fb_count, :integer, :default => 0
    remove_column :visualizations, :fb_count
  end
end
