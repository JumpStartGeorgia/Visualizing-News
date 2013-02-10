class AddIsPublic < ActiveRecord::Migration
  def change
    add_column :ideas, :is_public, :boolean, :default => true
    add_index :ideas, :is_public
    add_column :idea_progresses, :is_public, :boolean, :default => true
    add_index :idea_progresses, :is_public
  end
end
