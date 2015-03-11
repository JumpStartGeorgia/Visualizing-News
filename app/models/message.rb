class Message
	include ActiveAttr::Model
  include ActiveModel::Validations

	attribute :name
	attribute :organization
	attribute :phone
	attribute :email
	attribute :subject
	attribute :message
	attribute :org_message
	attribute :what_is_data
	attribute :why_visualize
	attribute :how_use
	attribute :url
	attribute :url_id
	attribute :bcc
	attribute :locale, :default => I18n.locale
  attribute :file
  attribute :datasource
  attribute :type
  
	# attr_accessible :name, :email, :message, :subject, :org_message, :url, :bcc, :url_id,
	#  :organization, :phone, :locale, :file, :datasource, :type, :what_is_data, :why_visualize, :how_use

#  validates_presence_of :email, :message => I18n.t('activerecord.errors.models.message.attributes.email.blank')
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :message, :maximum => 500
  validate :validate_by_type

  TYPES = {:submit_visual => 1, :send_data => 2}
  
  def validate_by_type
    missing_fields = []
    error_message = nil
    
    if self.type == TYPES[:submit_visual].to_s
      missing_fields << :name if !self.name || self.name.empty?
      missing_fields << :how_use if !self.how_use || self.how_use.empty?

      error_message = I18n.t('activerecord.errors.messages.submit_visual_missing_fields')

    elsif self.type == TYPES[:send_data].to_s
      missing_fields << :name if !self.name || self.name.empty?
      missing_fields << :what_is_data if !self.what_is_data || self.what_is_data.empty?
      missing_fields << :why_visualize if !self.why_visualize || self.why_visualize.empty?
      missing_fields << :datasource if !self.datasource || self.datasource.empty?

      error_message = I18n.t('activerecord.errors.messages.send_data_missing_fields')

    else
      missing_fields << :message if !self.message || self.message.empty?

      error_message = I18n.t('activemodel.errors.models.message.attributes.message.blank')
    end

    if !missing_fields.empty?
      missing_fields.each do |field|
        errors.add(field, error_message)
      end
    end

  end
end
