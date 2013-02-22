class AddIdeaDeletedFlag < ActiveRecord::Migration
  def change
    add_column :ideas, :is_deleted, :boolean, :default => false
    add_index :ideas, :is_deleted
  end
end
