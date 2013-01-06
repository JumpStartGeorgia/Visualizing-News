class VisualizationTranslation < ActiveRecord::Base
	require 'utf8_converter'
  has_permalink :create_permalink

	belongs_to :visualization

  attr_accessible :visualization_id, :locale, :title, :explanation,	:reporter, :designer,	:data_source_name, :permalink

  validates :title, :permalink, :presence => true


  # when a record is published, the following fields must be provided
  # - reporter, designer, data source name
  # -> this method is called from the visualization model
  def validate_if_published
    missing_fields = []
    missing_fields << :title if !self.title || self.title.empty?
    missing_fields << :explanation if !self.explanation || self.explanation.empty?
    missing_fields << :reporter if !self.reporter || self.reporter.empty?
    missing_fields << :designer if !self.designer || self.designer.empty?
    missing_fields << :data_source_name if !self.data_source_name || self.data_source_name.empty?

    if !missing_fields.empty?
      missing_fields.each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
      end
    end

    return missing_fields
  end


  def create_permalink
    Utf8Converter.convert_ka_to_en(self.title) if self.title
  end

  def self.get_visual_id(permalink)
    x = select(:visualization_id).where(:permalink => permalink, :locale => I18n.locale).first
		if x
			return x.visualization_id
		else
			nil
		end
  end

end
