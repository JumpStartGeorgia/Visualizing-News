class IdeaStatus < ActiveRecord::Base
	translates :name

	has_many :idea_status_translations, :dependent => :destroy
  accepts_nested_attributes_for :idea_status_translations

  attr_accessible :id, :sort, :is_published, :idea_status_translations_attributes

	scope :sorted, order("sort asc")
end
