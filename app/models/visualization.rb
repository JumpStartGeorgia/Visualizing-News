class Visualization < ActiveRecord::Base
  is_impressionable :counter_cache => true
	translates :title, :explanation, :reporter, :designer, :developer,
		:interactive_url,	:permalink, :fb_count, :visualization_text, :video_url,
    :video_embed
  scoped_search :in => :visualization_translations, :on => [:title, :explanation]


  require 'split_votes'
  include SplitVotes

  TYPES = {:infographic => 1, :interactive => 2, :fact => 3, :comic => 4, :video => 5}

	has_many :visualization_categories, :dependent => :destroy
	has_many :categories, :through => :visualization_categories
	has_many :visualization_translations, :dependent => :destroy
	belongs_to :organization

  accepts_nested_attributes_for :visualization_translations, allow_destroy: true

	attr_accessible :published_date,
      :published,
      :visualization_type_id,
      :individual_votes,
      :overall_votes,
			:dataset_old,
			:visual_old,
			:visualization_translations_attributes,
			:category_ids,
			:organization_id,
			:interactive_url_old,
			:visual_is_cropped_old,
			:data_source_url_old,
			:languages, :languages_internal,
      :is_promoted, :promoted_at,
      :fb_likes, :reset_languages
	attr_accessor :send_notification, :was_published, :languages_internal, :reset_languages, :visualization_locale

 paginates_per 8

	after_find :check_if_published
  after_find :load_languages_internal
  after_find :set_visualization_locale

	# have to check if published exists because some find methods do not get the published attribute
	def check_if_published
		self.was_published = self.has_attribute?(:published) && self.published ? true : false
	end

  # set the languages internal local variable
  def load_languages_internal
    self.languages_internal = self.languages.split(',') if self.languages.present?
  end

  # set the locale to use for this visualization
  def set_visualization_locale(locale=I18n.locale)
    self.visualization_locale = locale.to_s
  end

	before_validation :set_languages
  validates :languages_internal, :organization_id, :visualization_type_id, :languages, :presence => true
  validates :visualization_type_id, :inclusion => {:in => TYPES.values}
	validate :required_fields_for_type
  validate :validate_if_published
  before_save :set_promoted_at

  scope :recent, order("visualizations.published_date DESC, visualization_translations.title ASC")
  scope :likes, order("visualizations.overall_votes DESC, visualization_translations.title ASC")
  scope :views, order("visualizations.impressions_count DESC, visualization_translations.title ASC")
  scope :published, where("published = '1'")
  scope :unpublished, where("published != '1'")
  scope :promoted, where("is_promoted = '1'")
  scope :not_promoted, where("is_promoted = '0'")

	def set_languages
    if self.languages_internal
      self.languages = self.languages_internal.delete_if{|x| x.empty?}.join(",")
    end
  end

  def set_promoted_at
    if self.is_promoted.nil?
      self.promoted_at = nil
    elsif self.is_promoted && self.promoted_at.nil?
      self.promoted_at = Date.today.strftime('%F')
    end
  end

  def image_text
    "#{self.title} - #{self.explanation} - #{self.visualization_text}"
  end

	# this validation is done here and not in trans obj because
	# when creating objs, the relationship between vis and trans do not exist
	# and so cannot get type id
  def required_fields_for_type
    missing_fields = []
    self.visualization_translations.each do |trans|
      if self.visualization_type_id == Visualization::TYPES[:infographic] ||
          self.visualization_type_id == Visualization::TYPES[:fact] ||
          self.visualization_type_id == Visualization::TYPES[:comic]
        missing_fields << :visual if trans.image_file_name.blank?
      elsif self.visualization_type_id == Visualization::TYPES[:interactive]
        missing_fields << :interactive_url if trans.interactive_url.blank?
        missing_fields << :visual if trans.image_file_name.blank?
      elsif self.visualization_type_id == Visualization::TYPES[:video]
        missing_fields << :video_url if trans.video_url.blank?
      end
    end
    if !missing_fields.empty?
      missing_fields.each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.required_field'))
      end
    end
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

      # validate each translation object
      self.visualization_translations.each do |trans|
        trans_errors << trans.validate_if_published
      end

      if !missing_fields.empty?
        missing_fields.each do |field|
          errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
        end
      end
=begin
      # if there were missing fields from the translation object, add the errors
      if !trans_errors.empty?
        trans_errors.flatten.each do |field|
          errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
        end
      end
=end
    end
  end

	def visualization_type_name(english_only=false)
    index = TYPES.values.index(self.visualization_type_id)
    if index
      if english_only
        I18n.t("visualization_types.#{Visualization::TYPES.keys[index]}", :locale => :en)
      else
        I18n.t("visualization_types.#{Visualization::TYPES.keys[index]}")
      end
    else # if not found, default to all
      if english_only
        I18n.t("visualization_types.all", :locale => :en)
      else
        I18n.t("visualization_types.all")
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

  def self.by_language(locale=I18n.locale)
    with_translations(locale)
  end

	def self.by_type(type_id)
		where(:visualization_type_id => type_id) if type_id
	end

  def self.by_category(category_id)
    joins(:visualization_categories).where(:visualization_categories => {:category_id => category_id})
  end

  def self.by_organization(organization_id)
    where(:organization_id => organization_id)
  end

  # have to override default method because permalink does not have to match current locale
  def self.find_by_permalink(permalink)
    joins(:visualization_translations).where('visualization_translations.permalink = ?', permalink).first
  end

	##############################
	## shortcut methods to get to
	## image file in image_file object
	##############################
	def image_record
		x = self.visualization_translations.select{|x| x.locale == self.visualization_locale}.first
    if x.present?
      return x.image_record
    end
    return nil
	end
	def image_file_name
		image_record.file_file_name if !image_record.blank?
	end
	def image
		image_record.file if !image_record.blank?
	end

	##############################
	## shortcut methods to get to
	## dataset file in dataset_file object
	##############################
	def dataset_record
		x = self.visualization_translations.select{|x| x.locale == self.visualization_locale}.first
    if x.present?
      return x.dataset_record
    end
    return nil
	end
	def dataset_file_name
		dataset_record.file_file_name if !dataset_record.blank?
	end
	def dataset
		dataset_record.file if !dataset_record.blank?
	end

	##############################
	## shortcut methods to get to
	## datasource records
	##############################
	def datasources
		self.visualization_translations.select{|x| x.locale == self.visualization_locale}.first.datasources
	end


	# check which visuals in trans objects need to be cropped
	def locales_to_crop
		to_crop = []
		self.visualization_translations.each do |trans|
			to_crop << trans.locale if !trans.image_is_cropped
		end
		return to_crop
	end


end
