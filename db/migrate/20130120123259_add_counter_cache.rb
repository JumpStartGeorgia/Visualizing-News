class AddCounterCache < ActiveRecord::Migration
  def change
    add_column :visualizations, :impressions_count, :integer, :default => 0
    add_index :visualizations, :impressions_count
  end
end
