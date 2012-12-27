class AddCropFlag < ActiveRecord::Migration
  def change
		add_column :visualizations, :visual_is_cropped, :boolean, :default => false
  end

end
