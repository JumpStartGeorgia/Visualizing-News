class CategoryTranslation < ActiveRecord::Base
	belongs_to :category

  attr_accessible :category_id, :name, :locale

  validates :name, :presence => true

end
