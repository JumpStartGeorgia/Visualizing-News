class MoveVisualCroppedData < ActiveRecord::Migration
  def up
    VisualizationTranslation.all.each do |trans|
			trans.upload_files.each do |upload|
				upload.image_is_cropped = trans.visual_is_cropped_old
				upload.save
			end
    end
  end

  def down
		UploadFile.update_all(:image_is_cropped => false)
  end
end
