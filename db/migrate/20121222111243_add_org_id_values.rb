class AddOrgIdValues < ActiveRecord::Migration
  def up
		# default any exist story records to jumpstart
		Story.where(:organization_id => nil).update_all(:organization_id => 1)
  end

  def down
		Story.where(:organization_id => 1).update_all(:organization_id => nil)
  end
end
