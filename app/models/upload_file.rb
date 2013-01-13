class UploadFile < ActiveRecord::Base
	belongs_to :visualization_translation

  TYPES = {:image => 1, :dataset => 2}

	attr_accessible :visualization_translation_id, :type_id, :upload, :upload_file_name,
			:crop_x, :crop_y, :crop_w, :crop_h, :reset_crop, :image_is_cropped

	attr_accessor :reset_crop, :was_cropped

  validates :type_id, :upload_file_name, :presence => true

	def type_name
    TYPES.keys[TYPES.values.index(self.type_id)].to_s
	end

	has_attached_file :upload,
    :url => :upload_url,
		:styles => Proc.new { |attachment| attachment.instance.attachment_styles}
	#:convert_options => {
  #     :thumb => "-gravity north -thumbnail 230x230^ -extent 230x230"
  # },

	def upload_url
		if self.type_id == TYPES[:image]
			"/system/visualizations/:visual_id/:type/:permalink_:locale_:style.:extension"
		elsif self.type_id == TYPES[:dataset]
			"/system/visualizations/:visual_id/:type/:filename"
		end
	end

	# if this is a new record, do not apply the cropping processor
	# - the user must be able to set the crop size first
	def attachment_styles
		if is_image?
			if self.id.nil? || self.crop_x.nil? || self.crop_y.nil? || self.crop_w.nil? || self.crop_h.nil?
				{
				  :thumb => {:geometry => "230x230#"},
				  :medium => {:geometry => "600x>"},
				  :large => {:geometry => "900x>"}
				}
			else
				{
				  :thumb => {:geometry => "230x230#", :processors => [:cropper]}
				}
			end
		end
	end

	# with new version of paperclip, can no longer run this as after update because
	# paperclip updates the file updated date after reprocessing, thus causing infinite loop
	# - reprocess_upload now called in edit controller
#  after_update :reprocess_upload, :if => :cropping?

	after_find :set_flags

	def set_flags
		self.was_cropped = self.image_is_cropped
	end

  def cropping?
    is_image? && image_is_cropped && !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def visual_geometry(style = :original)
    geometry ||= {}
    geometry[style] ||= Paperclip::Geometry.from_file(upload.path(style))
  end

	def is_image?
		self.type_id == TYPES[:image]
	end

#private
	def reprocess_upload
		self.upload.reprocess!
	end

end
