class Visualization < ActiveRecord::Base
	translates :title, :explanation,	:reporter, :designer,	:data_source_name

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
      :data_source_url,
      :individual_votes,
      :overall_votes,
			:dataset,
			:visual,
			:visualization_translations_attributes,
			:category_ids,
			:organization_id,
			:interactive_url,
			:visual_is_cropped,
			:crop_x, :crop_y, :crop_w, :crop_h, :cropping_started

	attr_accessor :is_create, :crop_x, :crop_y, :crop_w, :crop_h, :cropping_started

	paginates_per 4


  validates :organization_id, :visualization_type_id, :presence => true
  validates :visualization_type_id, :inclusion => {:in => TYPES.values}
	validates :visual_file_name, :presence => true, :if => "visualization_type_id == 1"
	validates :interactive_url, :presence => true, :if => "visualization_type_id == 2"
  validate :validate_if_published

  scope :recent, lambda {with_translations(I18n.locale).order("visualizations.published_date DESC, visualization_translations.title ASC")}
  scope :published, where("published = '1'")
  scope :unpublished, where("published = '0'")


	has_attached_file :dataset,
    :url => "/system/visualization/:attachment/:id/:filename",
    :path => ":rails_root/public/system/visualization/:attachment/:id/:filename"

	has_attached_file :visual,
    :url => "/system/visualization/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/visualization/:attachment/:id/:style/:filename",
		:styles => Proc.new { |attachment| attachment.instance.attachment_styles}
	#:convert_options => {
  #     :thumb => "-gravity north -thumbnail 230x230^ -extent 230x230"
  # },

	# if this is a new record, do not apply the cropping processor
	# - the user must be able to set the crop size first
	def attachment_styles
	  if self.id.nil? || self.crop_x.nil? || self.crop_y.nil? || self.crop_w.nil? || self.crop_h.nil?
			{
		    :thumb => {:geometry => "230x230#"},
		    :medium => {:geometry => "600x>"},
		    :large => {:geometry => "900x>"}
		  }
		else
			{
		    :thumb => {:geometry => "230x230#", :processors => [:cropper]}
		  }
		end
	end

  after_update :reprocess_visual, :if => :cropping?

  def cropping?
    visual_is_cropped && !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def visual_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(visual.path(style))
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


  private
   def reprocess_visual
     visual.reprocess!
   end

end
