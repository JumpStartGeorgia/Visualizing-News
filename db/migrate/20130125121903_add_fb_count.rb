class AddFbCount < ActiveRecord::Migration
  def change
    add_column :visualizations, :fb_count, :integer, :default => 0
  end
end
