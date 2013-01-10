class AddNewPages < ActiveRecord::Migration
  def up
		Page.where(:name => 'get_involved').destroy_all
		p = Page.create(:name => 'submit_visual')
		p.page_translations.create(:locale => 'ka', :title => 'Submit a Visual', :description => '...')
		p.page_translations.create(:locale => 'en', :title => 'Submit a Visual', :description => '...')
		p = Page.create(:name => 'terms')
		p.page_translations.create(:locale => 'ka', :title => 'Terms of Service', :description => '...')
		p.page_translations.create(:locale => 'en', :title => 'Terms of Service', :description => '...')
  end

  def down
		Page.where(:name => 'submit_visual').destroy_all
		Page.where(:name => 'terms').destroy_all
		p = Page.create(:name => 'get_involved')
		p.page_translations.create(:locale => 'ka', :title => 'Get Involved', :description => '...')
		p.page_translations.create(:locale => 'en', :title => 'Get Involved', :description => '...')
  end
end
