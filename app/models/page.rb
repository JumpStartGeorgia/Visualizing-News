class Page < ActiveRecord::Base
	translates :title, :description

  has_many :page_translations, :dependent => :destroy
  accepts_nested_attributes_for :page_translations
  attr_accessible :name, :page_translations_attributes

  validates :name, :presence => true

end
