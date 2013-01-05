class AddVisualPermalinks < ActiveRecord::Migration
  def up
    VisualizationTranslation.all.each do |trans|
      trans.generate_permalink!
      trans.save
    end
  end

  def down
    VisualizationTranslation.update_all(:permalink => nil)
  end
end
