class Story < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name

	has_many :story_categories, :dependent => :destroy
	has_many :story_translations, :dependent => :destroy
	belongs_to :story_type

	has_attached_file :dataset,
    :url => "/system/story/:attachment/:id/:filename",
    :path => ":rails_root/public/system/story/:attachment/:id/:filename"

	has_attached_file :visual,
    :url => "/system/story/:attachment/:id/:filename",
    :path => ":rails_root/public/system/story/:attachment/:id/:filename"

  accepts_nested_attributes_for :story_translations
  accepts_nested_attributes_for :story_categories

	attr_accessible :published_date,
      :published,
      :story_type_id,
      :data_source_url,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visual,
			:story_translations_attributes,
			:story_categories_attributes
	attr_accessor :is_create

  validates :story_type_id, :presence => true

end
