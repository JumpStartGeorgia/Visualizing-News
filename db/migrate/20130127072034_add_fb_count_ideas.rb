class AddFbCountIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :fb_count, :integer, :default => 0
  end
end
