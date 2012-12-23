class Visualization < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name

  require 'split_votes'
  include SplitVotes


	paginates_per 2

	has_many :visualization_categories, :dependent => :destroy
	has_many :categories, :through => :visualization_categories
	has_many :visualization_translations, :dependent => :destroy
	belongs_to :visualization_type
	belongs_to :organization

	has_attached_file :dataset,
    :url => "/system/visualization/:attachment/:id/:filename",
    :path => ":rails_root/public/system/visualization/:attachment/:id/:filename"

	has_attached_file :visual,
    :url => "/system/visualization/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/visualization/:attachment/:id/:style/:filename",
		:styles => {
      :thumb => "",
      :medium => "600x>",
			:large => "900x>" },
		:convert_options => {
        :thumb => "-gravity north -thumbnail 220x220^ -extent 220x220"
    }

  accepts_nested_attributes_for :visualization_translations

	attr_accessible :published_date,
      :published,
      :visualization_type_id,
      :data_source_url,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visual,
			:visualization_translations_attributes,
			:category_ids,
			:organization_id

	attr_accessor :is_create

  validates :visualization_type_id, :presence => true

  scope :recent, lambda {with_translations(I18n.locale).order("visualizations.published_date DESC, visualization_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")

end
