class AddPageText < ActiveRecord::Migration
  def up
		p = Page.find_by_name('submit_visual')
		p.page_translations.each do |trans|
			trans.description = "You too can contribute your visual ideas or any idea posted on the ideas webpage. Go ahead and register below and begin posting your visuals under your or your organization's name!

If you are interested in visualizing data, but do not know how to do it, get in touch with us. We would love to invite you to our office, share our knowledge and experience, and welcome you to data visualization community!"
			trans.save
		end

		p = Page.find_by_name('data')
		p.page_translations.each do |trans|
			trans.title = 'Send Data'
			trans.description = "Do you have data that you would like to see visualized, but do not have the time or skills? Share your data here! If it is interesting, there is a good chance someone will use it, which means you can then reuse their visualization. By sharing with the community, you are becoming part of something larger in which everyone involved benefits.

If you are interested in visualizing data, but do not know how to do it, get in touch with us. We would love to invite you to our office, share our knowledge and experience, and welcome you to data visualization community!"
			trans.save
		end
  end

  def down
		# do nothing
  end
end
