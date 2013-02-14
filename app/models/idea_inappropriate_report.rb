class IdeaInappropriateReport < ActiveRecord::Base
	belongs_to :user
	belongs_to :idea

	after_save :mark_idea_as_inappropriate

	attr_accessible :user_id, :idea_id, :reason, 
      :created_at, :updated_at
  attr_accessor :type

  validates :idea_id, :reason, :presence => true


	# if the idea has been reported > 2 times,
	# mark idea as inappropriate
	def mark_idea_as_inappropriate
		reports = IdeaInappropriateReport.where(:idea_id => self.idea_id)
		if reports && reports.length > 2
			idea = Idea.find_by_id(self.idea_id)
				if idea
					idea.is_inappropriate = true
					idea.save
				end
		end
	end

	# form is double reporting so check if record already exists
	def save
		record = IdeaInappropriateReport.where("idea_id = ? and user_id = ? and created_at > ?",
				self.idea_id, self.user_id, Time.now-1.minute
		)

		if record && !record.empty?
logger.debug "IdeaInappropriateReport record was just saved, so skip"
			# already exists
			return true
		else
			super
		end
	end
end
