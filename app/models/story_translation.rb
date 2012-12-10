class StoryTranslation < ActiveRecord::Base
	belongs_to :story

  attr_accessible :story_id, :locale, :title, :explanation,	:reporter, :designer,	:data_source_name

  validates :title, :explanation, :presence => true

end
