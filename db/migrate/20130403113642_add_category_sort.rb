class AddCategorySort < ActiveRecord::Migration
  def change
    add_column :categories, :sort_order, :integer, :default => 1
    add_index :categories, :sort_order 
  end
end
