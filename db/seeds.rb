########## Story Type ##########################
StoryType.delete_all
type = StoryType.create(:id => 1)
type.story_type_translations.create(:locale => 'ka', :name => 'Infographic')
type.story_type_translations.create(:locale => 'en', :name => 'Infographic')
type = StoryType.create(:id => 2)
type.story_type_translations.create(:locale => 'ka', :name => 'Interactive')
type.story_type_translations.create(:locale => 'en', :name => 'Interactive')
