class AddOrgBio < ActiveRecord::Migration
  def change
		add_column :organization_translations, :bio, :text
  end

end
