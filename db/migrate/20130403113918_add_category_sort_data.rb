# encoding: UTF-8
class AddCategorySortData < ActiveRecord::Migration
  def up
    cat = Category.create(:id => 13, :sort_order => 0, :icon_file_name => 'all.png', :icon_content_type => 'image/png', :icon_file_size => 1102, :icon_updated_at => '2013-04-03 10:07:27')
    cat.category_translations.create(:locale => 'ka', :name => 'ყველა')
    cat.category_translations.create(:locale => 'en', :name => 'All')
  end

  def down
    Category.update_all(:sort_order => 1)
  end
end
