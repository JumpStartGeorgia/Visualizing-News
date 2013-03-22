class AddFbLikeCounter < ActiveRecord::Migration
  def change
    add_column :visualizations, :fb_likes, :integer, :default => 0
    add_column :ideas, :fb_likes, :integer, :default => 0
  end
end
