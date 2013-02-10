class AddLanguageValues < ActiveRecord::Migration
  def up
		Visualization.where(:languages => nil).update_all(:languages => 'en,ka')
  end

  def down
		# do nothing
  end
end
