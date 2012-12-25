# encoding: UTF-8
########## Visualization Type ##########################
=begin
puts "visualization types"
VisualizationType.delete_all
VisualizationTypeTranslation.delete_all
type = VisualizationType.create(:id => 1)
type.visualization_type_translations.create(:locale => 'ka', :name => 'Infographic')
type.visualization_type_translations.create(:locale => 'en', :name => 'Infographic')
type = VisualizationType.create(:id => 2)
type.visualization_type_translations.create(:locale => 'ka', :name => 'Interactive')
type.visualization_type_translations.create(:locale => 'en', :name => 'Interactive')
=end
######### Categories ##########################
puts "categories"
Category.delete_all
CategoryTranslation.delete_all
cat = Category.create(:id => 1)
cat.category_translations.create(:locale => 'ka', :name => 'გარემო')
cat.category_translations.create(:locale => 'en', :name => 'Environment')
cat = Category.create(:id => 2)
cat.category_translations.create(:locale => 'ka', :name => 'ეკონომიკა / ბიზნესი')
cat.category_translations.create(:locale => 'en', :name => 'Economy / Business')
cat = Category.create(:id => 3)
cat.category_translations.create(:locale => 'ka', :name => 'ჯანმრთელობა / საზოგადოებრივი უსაფრთხოება')
cat.category_translations.create(:locale => 'en', :name => 'Health / Public Safety')
cat = Category.create(:id => 4)
cat.category_translations.create(:locale => 'ka', :name => 'განათლება')
cat.category_translations.create(:locale => 'en', :name => 'Education')
cat = Category.create(:id => 5)
cat.category_translations.create(:locale => 'ka', :name => 'პოლიტიკა')
cat.category_translations.create(:locale => 'en', :name => 'Politics')
cat = Category.create(:id => 6)
cat.category_translations.create(:locale => 'ka', :name => 'ცხოვრების სტილი / კულტურა')
cat.category_translations.create(:locale => 'en', :name => 'Lifestyle / Culture')
cat = Category.create(:id => 7)
cat.category_translations.create(:locale => 'ka', :name => 'სპორტი')
cat.category_translations.create(:locale => 'en', :name => 'Sports')
cat = Category.create(:id => 8)
cat.category_translations.create(:locale => 'ka', :name => 'ტექნოლოგია / მეცნიერება')
cat.category_translations.create(:locale => 'en', :name => 'Technology / Science')
cat = Category.create(:id => 9)
cat.category_translations.create(:locale => 'ka', :name => 'მსოფლიო')
cat.category_translations.create(:locale => 'en', :name => 'World')
cat = Category.create(:id => 10)
cat.category_translations.create(:locale => 'ka', :name => 'სამხედრო თავდაცვა')
cat.category_translations.create(:locale => 'en', :name => 'Defence')
cat = Category.create(:id => 11)
cat.category_translations.create(:locale => 'ka', :name => 'სამართალი')
cat.category_translations.create(:locale => 'en', :name => 'Justice')
cat = Category.create(:id => 12)
cat.category_translations.create(:locale => 'ka', :name => 'საზოგადოება')
cat.category_translations.create(:locale => 'en', :name => 'Society')

######### Pages ##########################
puts "pages"
Page.delete_all
PageTranslation.delete_all
p = Page.create(:name => 'about')
p.page_translations.create(:locale => 'ka', :title => 'About', :description => '...')
p.page_translations.create(:locale => 'en', :title => 'About', :description => '...')
p = Page.create(:name => 'get_involved')
p.page_translations.create(:locale => 'ka', :title => 'Get Involved', :description => '...')
p.page_translations.create(:locale => 'en', :title => 'Get Involved', :description => '...')
p = Page.create(:name => 'data')
p.page_translations.create(:locale => 'ka', :title => 'Got Data?', :description => '...')
p.page_translations.create(:locale => 'en', :title => 'Got Data?', :description => '...')

########### Organization ####################
puts "organizations"
Organization.delete_all
OrganizationTranslation.delete_all
org = Organization.create(:id => 1, :url => "http://jumpstart.ge",
	:logo_file_name => "jumpstart-logo.png", :logo_content_type => "image/png",
	:logo_file_size => 3538, :logo_updated_at => Time.now)
org.organization_translations.create(:locale => 'ka', :name => 'JumpStart Georgia')
org.organization_translations.create(:locale => 'en', :name => 'JumpStart Georgia')
