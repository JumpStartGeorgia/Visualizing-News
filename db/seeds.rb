# encoding: UTF-8
########## Story Type ##########################
puts "story types"
StoryType.delete_all
StoryTypeTranslation.delete_all
type = StoryType.create(:id => 1)
type.story_type_translations.create(:locale => 'ka', :name => 'Infographic')
type.story_type_translations.create(:locale => 'en', :name => 'Infographic')
type = StoryType.create(:id => 2)
type.story_type_translations.create(:locale => 'ka', :name => 'Interactive')
type.story_type_translations.create(:locale => 'en', :name => 'Interactive')

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
