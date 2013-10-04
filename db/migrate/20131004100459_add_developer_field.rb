# encoding: UTF-8
class AddDeveloperField < ActiveRecord::Migration
  def up
    add_column :visualization_translations, :developer, :string
    
    # add in names for developer
    titles = ["Timeline of Georgia 2012", "Mashasada.me", "What To Expect When You Quit Smoking", "WHO DO GEORGIANS TRUST?", "Speaking Stones", "Speaking Stones (II)", "2013 Timeline of Georgia", "The Known Soldier", "Georgia Election Data"]
    
    VisualizationTranslation.transaction do
      ids = VisualizationTranslation.select('distinct visualization_id').where(:title => titles, :locale => 'en')
      
      if ids.present?
        VisualizationTranslation.where(:visualization_id => ids.map{|x| x.visualization_id}, :locale => 'en')
          .update_all(:developer => 'Vazha Asatiani, Jason Addie (JumpStart Georgia)')
        VisualizationTranslation.where(:visualization_id => ids.map{|x| x.visualization_id}, :locale => 'ka')
          .update_all(:developer => 'ვაჟა ასათიანი, ჯეისონ ედი (ჯამპსტარტ ჯორჯია)')
      end
      
    end    
  end

  def down
    remove_column :visualization_translations, :developer
  end
end
