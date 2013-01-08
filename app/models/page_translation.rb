class PageTranslation < ActiveRecord::Base
  attr_accessible :page_id, :title, :description, :locale
  belongs_to :page

  validates :title, :description, :locale, :presence => true

end
