class VisualizationTranslation < ActiveRecord::Base
	belongs_to :visualization

  attr_accessible :visualization_id, :locale, :title, :explanation,	:reporter, :designer,	:data_source_name

  validates :title, :explanation, :presence => true


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

end
