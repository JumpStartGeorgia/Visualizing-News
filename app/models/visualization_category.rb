class VisualizationCategory < ActiveRecord::Base
	belongs_to :visualization
	belongs_to :category

	attr_accessible :visualization_id, :category_id

  validates :visualization_id, :category_id, :presence => true
end
