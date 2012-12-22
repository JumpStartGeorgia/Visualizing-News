class Story < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name

  require 'split_votes'
  include SplitVotes


	paginates_per 2

	has_many :story_categories, :dependent => :destroy
	has_many :categories, :through => :story_categories
	has_many :story_translations, :dependent => :destroy
	belongs_to :story_type
	belongs_to :organization

	has_attached_file :dataset,
    :url => "/system/story/:attachment/:id/:filename",
    :path => ":rails_root/public/system/story/:attachment/:id/:filename"

	has_attached_file :visual,
    :url => "/system/story/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/story/:attachment/:id/:style/:filename",
		:styles => {
      :thumb => "",
      :medium => "600x>",
			:large => "900x>" },
		:convert_options => {
        :thumb => "-gravity north -thumbnail 220x220^ -extent 220x220"
    }

  accepts_nested_attributes_for :story_translations

	attr_accessible :published_date,
      :published,
      :story_type_id,
      :data_source_url,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visual,
			:story_translations_attributes,
			:category_ids,
			:organization_id

	attr_accessor :is_create

  validates :story_type_id, :presence => true

  scope :recent, lambda {with_translations(I18n.locale).order("stories.published_date DESC, story_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")

end
