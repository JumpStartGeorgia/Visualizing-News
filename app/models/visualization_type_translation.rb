class VisualizationTypeTranslation < ActiveRecord::Base
	belongs_to :visualization_type

  attr_accessible :visualization_type_id, :name, :locale

  validates :name, :presence => true

end
