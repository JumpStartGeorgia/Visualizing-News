class Visualization < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name

  require 'split_votes'
  include SplitVotes

  TYPES = {:infographic => 1, :interactive => 2}

	paginates_per 4

	has_many :visualization_categories, :dependent => :destroy
	has_many :categories, :through => :visualization_categories
	has_many :visualization_translations, :dependent => :destroy
#	belongs_to :visualization_type
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
        :thumb => "-gravity north -thumbnail 180x180^ -extent 180x180"
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
			:organization_id,
			:interactive_url

	attr_accessor :is_create

  validates :organization_id, :visualization_type_id, :presence => true
  validates :visualization_type_id, :inclusion => {:in => TYPES.values}
	validates :visual_file_name, :presence => true, :if => "visualization_type_id == 1"
	validates :interactive_url, :presence => true, :if => "visualization_type_id == 2"
  validate :validate_if_published

  scope :recent, lambda {with_translations(I18n.locale).order("visualizations.published_date DESC, visualization_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")


  # when a record is published, the following fields must be provided
  # - published date, visual file, at least one category,
  #   reporter, designer, data source name
  def validate_if_published
    if self.published
      missing_fields = []
      trans_errors = []
      missing_fields << :published_date if !self.published_date
      missing_fields << :categories if !self.categories || self.categories.empty?

			if self.visualization_type_id == Visualization::TYPES[:infographic]
	      missing_fields << :visual if !self.visual_file_name || self.visual_file_name.empty?
			elsif self.visualization_type_id == Visualization::TYPES[:interactive]
	      missing_fields << :interactive_url if !self.interactive_url || self.interactive_url.empty?
	      missing_fields << :visual if !self.visual_file_name || self.visual_file_name.empty?
			end
      self.visualization_translations.each do |trans|
        trans_errors << trans.validate_if_published
      end

      if !missing_fields.empty?
        missing_fields.each do |field|
          errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
        end
      end

      # if there were missing fields from the translation object, add the errors
      if !trans_errors.empty?
        trans_errors.flatten.each do |field|
          errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
        end
      end

    end
  end

	def self.type_id(name)
		id = nil
		if name
			index = TYPES.keys.index{|x| x.to_s.downcase == name.downcase}
			id = TYPES[TYPES.keys[index]] if index
		end
		return id
	end

	def self.by_type(type_id)
		where(:visualization_type_id => type_id) if type_id
	end

end
