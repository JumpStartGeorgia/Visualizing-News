class Visualization < ActiveRecord::Base

  after_update :reprocess_visual, :if => :cropping?

  def cropping?
    !cropping_started.blank? && cropping_started == 'true' && !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def visual_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(visual.path(style))
  end

	translates :title, :explanation,	:reporter, :designer,	:data_source_name

  require 'split_votes'
  include SplitVotes


	paginates_per 4

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
      :thumb => {:geometry => "180x180#", :processors => [:cropper]},
      :medium => {:geometry => "600x>"},
      :large => {:geometry => "900x>"}
    }
	#:convert_options => {
  #     :thumb => "-gravity north -thumbnail 180x180^ -extent 180x180"
  # },

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
			:crop_x, :crop_y, :crop_w, :crop_h, :cropping_started

	attr_accessor :is_create, :crop_x, :crop_y, :crop_w, :crop_h, :cropping_started

  validates :organization_id, :visualization_type_id, :presence => true

  scope :recent, lambda {with_translations(I18n.locale).order("visualizations.published_date DESC, visualization_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")

  validate :validate_if_published

  # when a record is published, the following fields must be provided
  # - published date, visual file, at least one category,
  #   reporter, designer, data source name
  def validate_if_published
    if self.published
      missing_fields = []
      trans_errors = []
      missing_fields << :published_date if !self.published_date
#      missing_fields << :visual if !self.visual_file_name || self.visual_file_name.empty?
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


  private
   def reprocess_visual
     visual.reprocess!
   end

end
