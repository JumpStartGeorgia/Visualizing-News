class IdeaStatusTranslation < ActiveRecord::Base
	belongs_to :idea_status

  attr_accessible :idea_status_id, :name, :locale

  validates :name, :presence => true

end
