class Visualization < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name,
						:permalink, :interactive_url, :visual, :visual_file_name, :visual_content_type,
						:fallbacks_for_empty_translations => true

  require 'split_votes'
  include SplitVotes

  TYPES = {:infographic => 1, :interactive => 2}

	has_many :visualization_categories, :dependent => :destroy
	has_many :categories, :through => :visualization_categories
	has_many :visualization_translations, :dependent => :destroy
	belongs_to :organization

  accepts_nested_attributes_for :visualization_translations#, :reject_if => lambda { |a| a[:title].nil? || a[:title].blank?}, :allow_destroy => true

	attr_accessible :published_date,
      :published,
      :visualization_type_id,
      :data_source_url,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visualization_translations_attributes,
			:category_ids,
			:organization_id,
			:languages, :languages_internal

	attr_accessor :send_notification, :was_published, :languages_internal

	paginates_per 4

	after_find :check_if_published

	# have to check if published exists because some find methods do not get the published attribute
	def check_if_published
		self.was_published = self.has_attribute?(:published) && self.published ? true : false
	end

  before_validation :set_languages
  validates :organization_id, :visualization_type_id, :languages, :presence => true
  validates :visualization_type_id, :inclusion => {:in => TYPES.values}
  validate :required_fields_for_type
  validate :validate_if_published

  scope :recent, lambda {with_translations(I18n.locale).order("visualizations.published_date DESC, visualization_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")


	has_attached_file :dataset,
    :url => "/system/visualization/:attachment/:id/:filename",
    :path => ":rails_root/public/system/visualization/:attachment/:id/:filename"

  def set_languages
    if self.languages_internal
      self.languages = self.languages_internal.delete_if{|x| x.empty?}.join(",")
    end
  end

  def required_fields_for_type
    missing_fields = []
    self.visualization_translations.each do |trans|
      if self.visualization_type_id == Visualization::TYPES[:infographic]
        missing_fields << :visual if !trans.visual_file_name || trans.visual_file_name.empty?
      elsif self.visualization_type_id == Visualization::TYPES[:interactive]
        missing_fields << :interactive_url if !trans.interactive_url || trans.interactive_url.empty?
        missing_fields << :visual if !trans.visual_file_name || trans.visual_file_name.empty?
      end
    end
    if !missing_fields.empty?
      missing_fields.each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.required_field'))
      end
    end
  end

  def is_infographic?
Rails.logger.debug "******************* is infographic called"
    x = self.visualization && self.visualization.visualization_type_id == Visualization::TYPES[:infographic]
Rails.logger.debug "******************* - result = #{x}"
    return x
  end

  def is_interactive?
Rails.logger.debug "******************* is interactive called"
    x = self.visualization && self.visualization.visualization_type_id == Visualization::TYPES[:interactive]
Rails.logger.debug "******************* - result = #{x}"
    return x
  end

  # when a record is published, the following fields must be provided
  # - published date, visual file, at least one category,
  #   reporter, designer, data source name
  def validate_if_published
    if self.published
      missing_fields = []
      trans_errors = []
      missing_fields << :published_date if !self.published_date
      missing_fields << :categories if !self.categories || self.categories.empty?

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

	def visualization_type_name
    name = TYPES.keys[TYPES.values.index(self.visualization_type_id)].to_s
		I18n.t("visualization_types.#{name}") if name
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

  def self.by_category(category_id)
    joins(:visualization_categories).where(:visualization_categories => {:category_id => category_id})
  end
=begin

  def visual
    self.visualization_translations.select{|x| x.locale == I18n.locale.to_s}.first.visual
  end
  def visual_file_name
    self.visualization_translations.select{|x| x.locale == I18n.locale.to_s}.first.visual_file_name
  end
=end

  # have to do test for fallbacks in case file does not exist in current locale
  def visual_url(style=:thumb, nothing=false)
    path = nil
    if self.id && self.permalink && self.visual_content_type
      ext = self.visual_content_type.split("/").last.gsub('jpeg', 'jpg')
      I18n.fallbacks[I18n.locale].each do |locale|
        x = "/system/visualizations/#{self.id}/#{self.permalink}_#{locale}_#{style}.#{ext}"
        if File.exist?("#{Rails.root}/public#{x}")
          path = x
          break
        end
      end
    end
    return path
  end
end
