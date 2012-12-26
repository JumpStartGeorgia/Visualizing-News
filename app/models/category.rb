class Category < ActiveRecord::Base
	translates :name

	has_many :visualization_categories, :dependent => :destroy
	has_many :visualizations, :through => :visualization_categories
	has_many :category_translations, :dependent => :destroy

	has_attached_file :icon,
    :url => "/system/category/:attachment/:id/:filename",
    :path => ":rails_root/public/system/category/:attachment/:id/:filename"

  accepts_nested_attributes_for :category_translations
  attr_accessible :id, :icon, :category_translations_attributes

  def permalink
    self.name.downcase.gsub(" ","_").gsub("/","_")
  end

end
