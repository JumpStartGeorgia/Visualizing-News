class AddVisTypeToImagesData < ActiveRecord::Migration
  def up
    Visualization.all.each do |vis|
      vis.visualization_translations.each do |trans|
        trans.image_file.visualization_type_id = vis.visualization_type_id
        trans.image_file.save
      end
    end
  end

  def down
    ImageFile.update_all(:visualization_type_id => nil)
  end
end
