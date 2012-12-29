class Organization < ActiveRecord::Base
	translates :name, :permalink

	has_many :visualizations, :as => :visualizations
	has_many :organization_users, :dependent => :destroy
	has_many :organization_translations, :dependent => :destroy
	has_attached_file :logo,
    :url => "/system/organization/:attachment/:id/:filename",
    :path => ":rails_root/public/system/organization/:attachment/:id/:filename"

  accepts_nested_attributes_for :organization_translations
  attr_accessible :logo, :organization_translations_attributes, :url, :id,
		:logo_file_name, :logo_content_type, :logo_file_size, :logo_updated_at

	def self.with_name
		with_translations(I18n.locale).order("organization_translations.name asc")
	end
end
