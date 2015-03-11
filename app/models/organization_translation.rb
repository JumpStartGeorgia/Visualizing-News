class OrganizationTranslation < ActiveRecord::Base
	require 'utf8_converter'
  has_permalink :create_permalink

	belongs_to :organization

  attr_accessible :organization_id, :name, :locale, :permalink, :bio

  validates :name, :permalink, :presence => true
	validates :name, :uniqueness => {:scope => :locale, :case_sensitive => false,
			:message => I18n.t('activerecord.errors.messages.already_exists')}
	validates :permalink, :uniqueness => {:scope => :locale, :case_sensitive => false,
			:message => I18n.t('activerecord.errors.messages.already_exists')}

  def create_permalink
    Utf8Converter.convert_ka_to_en(self.name).to_ascii
  end

  def self.get_org_id(permalink)
    x = select(:organization_id).where(:permalink => permalink, :locale => I18n.locale).first
		if x
			return x.organization_id
		else
			nil
		end
  end

end
