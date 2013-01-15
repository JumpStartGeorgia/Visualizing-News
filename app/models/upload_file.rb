####################################
####################################
## THIS FILE IS NO LONGER USED
## ONLY HERE SO MIGRATIONS WORK
####################################
####################################
class UploadFile < ActiveRecord::Base
	belongs_to :visualization_translation

	attr_accessible :visualization_translation_id, :type_id,
			:upload, :upload_file_name, :upload_content_type, :upload_file_size, :upload_updated_at,
			:crop_x, :crop_y, :crop_w, :crop_h, :reset_crop, :image_is_cropped

	attr_accessor :reset_crop, :was_cropped

	TYPES = {:image => 1, :dataset => 2}


end
