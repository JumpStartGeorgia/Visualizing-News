class AddMissingIndexes < ActiveRecord::Migration
  def up
    add_index :pages, :name
    add_index :visualizations, :published
    add_index :visualizations, :published_date

  end

  def down
    remove_index :pages, :name
    remove_index :visualizations, :published
    remove_index :visualizations, :published_date
  end
end
