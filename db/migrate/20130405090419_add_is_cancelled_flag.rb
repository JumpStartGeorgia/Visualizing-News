class AddIsCancelledFlag < ActiveRecord::Migration
  def change
    add_column :idea_statuses, :is_cancelled, :boolean, :default => false
    add_column :idea_progresses, :is_cancelled, :boolean, :default => false
    add_index :idea_statuses, :is_cancelled
    add_index :idea_progresses, :is_cancelled
  end
end
