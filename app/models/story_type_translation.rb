class StoryTypeTranslation < ActiveRecord::Base
	belongs_to :story_type

  attr_accessible :story_type_id, :name, :locale

  validates :name, :presence => true

end
