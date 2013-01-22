# encoding: UTF-8
class AddIdeasStatusText < ActiveRecord::Migration
  def up
    IdeaStatus.delete_all
    IdeaStatusTranslation.delete_all
    stat = IdeaStatus.create(:id => 1, :sort => 1)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'არჩეულია')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Chosen')
    stat = IdeaStatus.create(:id => 2, :sort => 2)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემები მოვითხოვეთ')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Data Requested')
    stat = IdeaStatus.create(:id => 3, :sort => 3)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემები მივიღეთ')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Data Received')
    stat = IdeaStatus.create(:id => 4, :sort => 4)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'მონაცემებს ვაანალიზებთ')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Analysing Data')
    stat = IdeaStatus.create(:id => 5, :sort => 5)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'ვაკეთებთ დიზაინს')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Designing')
    stat = IdeaStatus.create(:id => 6, :sort => 6)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'გამოსაქვეყნებელია')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Waiting for Pub')
    stat = IdeaStatus.create(:id => 7, :sort => 7, :is_published => true)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'გამოქვეყნებულია')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Published')
    stat = IdeaStatus.create(:id => 8, :sort => 8)
    stat.idea_status_translations.create(:locale => 'ka', :name => 'გაუქმებულია')
    stat.idea_status_translations.create(:locale => 'en', :name => 'Cancelled')
  end

  def down
    IdeaStatus.delete_all
    IdeaStatusTranslation.delete_all
  end
end
