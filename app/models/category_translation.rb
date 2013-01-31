class CategoryTranslation < ActiveRecord::Base
	require 'utf8_converter'
	belongs_to :category

  attr_accessible :category_id, :name, :locale

  validates :name, :presence => true


  def permalink
    Utf8Converter.convert_ka_to_en(self.name.downcase.gsub(" ","_").gsub("/","_").gsub("__","_").gsub("__","_"))
  end


end
