class Visualization < ActiveRecord::Base
	translates :title, :explanation, :reporter, :designer,
		:interactive_url,	:data_source_name, :permalink, :data_source_url


  require 'split_votes'
  include SplitVotes

  TYPES = {:infographic => 1, :interactive => 2}

	has_many :visualization_categories, :dependent => :destroy
	has_many :categories, :through => :visualization_categories
	has_many :visualization_translations, :dependent => :destroy
	belongs_to :organization

  accepts_nested_attributes_for :visualization_translations

	attr_accessible :published_date,
      :published,
      :visualization_type_id,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visual_old,
			:visualization_translations_attributes,
			:category_ids,
			:organization_id,
			:interactive_url_old,
			:visual_is_cropped_old,
			:data_source_url_old,
			:languages, :languages_internal
	attr_accessor :send_notification, :was_published, :languages_internal

 paginates_per 8

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
  scope :unpublished, where("published != '1'")

	def set_languages
    if self.languages_internal
      self.languages = self.languages_internal.delete_if{|x| x.empty?}.join(",")
    end
  end

	# this validation is done here and not in trans obj because
	# when creating objs, the relationship between vis and trans do not exist
	# and so cannot get type id
  def required_fields_for_type
    missing_fields = []
    self.visualization_translations.each do |trans|
      if self.visualization_type_id == Visualization::TYPES[:infographic]
        missing_fields << :visual if trans.image_file_name.blank?
      elsif self.visualization_type_id == Visualization::TYPES[:interactive]
        missing_fields << :interactive_url if trans.interactive_url.blank?
        missing_fields << :visual if trans.image_file_name.blank?
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

	def image_record
		self.visualization_translations.select{|x| x.locale == I18n.locale.to_s}.first.image_record
	end

	def image_file_name
		image_record.upload_file_name if !image_record.blank?
	end

	def image
		image_record.upload if !image_record.blank?
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
