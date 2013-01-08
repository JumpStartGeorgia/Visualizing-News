class AddOrgIdToVisuals < ActiveRecord::Migration
  def change
		add_column :stories, :organization_id, :integer
		add_index :stories, :organization_id
  end
end
