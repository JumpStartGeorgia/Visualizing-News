class VisualizationTranslation < ActiveRecord::Base
	belongs_to :visualization

  attr_accessible :visualization_id, :locale, :title, :explanation,	:reporter, :designer,	:data_source_name

  validates :title, :explanation, :presence => true

end
