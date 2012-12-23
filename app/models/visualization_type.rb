class VisualizationType < ActiveRecord::Base
	translates :name

	has_many :visualization_type_translations, :dependent => :destroy
	has_many :visualizations

  accepts_nested_attributes_for :visualization_type_translations
  attr_accessible :id, :visualization_type_translations_attributes


end
