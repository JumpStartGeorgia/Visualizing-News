class Category < ActiveRecord::Base
	translates :name
	require 'utf8_converter'

	has_many :visualization_categories, :dependent => :destroy
	has_many :visualizations, :through => :visualization_categories
	has_many :category_translations, :dependent => :destroy

	has_attached_file :icon,
    :url => "/system/category/:attachment/:id/:filename",
    :path => ":rails_root/public/system/category/:attachment/:id/:filename"

  accepts_nested_attributes_for :category_translations
  attr_accessible :id, :icon, :category_translations_attributes, :icon_content_type, :icon_file_size, :icon_updated_at, :icon_file_name

  def permalink
    Utf8Converter.convert_ka_to_en(self.name.downcase.gsub(" ","_").gsub("/","_").gsub("__","_").gsub("__","_"))
  end

	def self.sorted
		with_translations(I18n.locale).order("category_translations.name asc")
	end

end
