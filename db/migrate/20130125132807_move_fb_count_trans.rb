class MoveFbCountTrans < ActiveRecord::Migration
  def up
    add_column :visualization_translations, :fb_count, :integer, :default => 0
    remove_column :visualizations, :fb_count
  end

  def down
#    remove_column :visualization_translations, :fb_count
    add_column :visualizations, :fb_count, :integer, :default => 0
  end
end
