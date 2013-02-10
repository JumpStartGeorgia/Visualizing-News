class Datasource < ActiveRecord::Base
  belongs_to :visualization_translation

	attr_accessible :name, :url

  validates :name, :presence => true
	validates :url, :format => {:with => URI::regexp(['http','https'])}, :if => "!url.blank?"


  # when a record is published, the following fields must be provided
  # - reporter, designer, data source name
  # -> this method is called from the visualization model
  def validate_if_published
    missing_fields = []
    missing_fields << :name if !self.name || self.name.empty?

    if !missing_fields.empty?
      missing_fields.each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.published_visual_missing_fields'))
      end
    end

    return missing_fields
  end

end
