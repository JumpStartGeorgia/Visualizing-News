class AddIdeasCounter < ActiveRecord::Migration
  def change
    add_column :ideas, :impressions_count, :integer, :default => 0
    add_index :ideas, :impressions_count
  end
end
