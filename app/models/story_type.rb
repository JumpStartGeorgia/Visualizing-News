class StoryType < ActiveRecord::Base
	translates :name

	has_many :story_type_translations, :dependent => :destroy
	has_many :stories

  accepts_nested_attributes_for :story_type_translations
  attr_accessible :id, :story_type_translations_attributes


end
