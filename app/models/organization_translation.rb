class OrganizationTranslation < ActiveRecord::Base
	belongs_to :organization

  attr_accessible :organization_id, :name, :locale

  validates :name, :presence => true

end
