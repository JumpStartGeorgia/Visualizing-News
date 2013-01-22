class IdeaCategory < ActiveRecord::Base
	belongs_to :idea
	belongs_to :category

	attr_accessible :idea_id, :category_id
end
