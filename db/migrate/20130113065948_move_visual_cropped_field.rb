class MoveVisualCroppedField < ActiveRecord::Migration
  def change
		add_column :upload_files, :image_is_cropped, :boolean, :default => false
		add_column :upload_files, :crop_x, :integer
		add_column :upload_files, :crop_y, :integer
		add_column :upload_files, :crop_w, :integer
		add_column :upload_files, :crop_h, :integer

		rename_column :visualization_translations, :visual_is_cropped, :visual_is_cropped_old
  end

end
