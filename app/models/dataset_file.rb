class DatasetFile < ActiveRecord::Base
	belongs_to :visualization_translation

	attr_accessible :visualization_translation_id,
			:file, :file_file_name, :file_content_type, :file_file_size, :file_updated_at

  validates :file_file_name, :presence => true

	has_attached_file :file,
    :url => "/system/visualizations/:visual_id/dataset/:locale/:filename"


end
