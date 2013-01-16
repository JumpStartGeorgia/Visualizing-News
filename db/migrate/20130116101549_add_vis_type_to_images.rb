class AddVisTypeToImages < ActiveRecord::Migration
  def change
    add_column :image_files, :visualization_type_id, :integer
  end
end
