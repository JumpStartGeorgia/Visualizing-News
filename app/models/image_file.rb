class ImageFile < ActiveRecord::Base
	belongs_to :visualization_translation

	attr_accessible :visualization_translation_id,
			:file, :file_file_name, :file_content_type, :file_file_size, :file_updated_at,
			:crop_x, :crop_y, :crop_w, :crop_h, :reset_crop, :image_is_cropped

	attr_accessor :reset_crop, :was_cropped

  validates :file_file_name, :presence => true

	has_attached_file :file,
    :url => "/system/visualizations/:visual_id/image/:permalink_:locale_:style.:extension",
		:styles => Proc.new { |attachment| attachment.instance.attachment_styles}
	#:convert_options => {
  #     :thumb => "-gravity north -thumbnail 230x230^ -extent 230x230"
  # },

	# if this is a new record, do not apply the cropping processor
	# - the user must be able to set the crop size first
	def attachment_styles
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

	# with new version of paperclip, can no longer run this as after update because
	# paperclip updates the file updated date after reprocessing, thus causing infinite loop
	# - reprocess_file now called in edit controller
#  after_update :reprocess_file, :if => :cropping?

	after_find :set_flags

	def set_flags
		self.was_cropped = self.image_is_cropped
	end

  def cropping?
    image_is_cropped && !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def visual_geometry(style = :original)
    geometry ||= {}
    geometry[style] ||= Paperclip::Geometry.from_file(file.path(style))
  end

#private
	def reprocess_file
		self.file.reprocess!
	end

end
