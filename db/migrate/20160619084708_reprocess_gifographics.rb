class ReprocessGifographics < ActiveRecord::Migration
  def up
    Visualization.where(visualization_type_id: Visualization::TYPES[:gifographic]).each do |viz|
      puts viz.title
      viz.visualization_translations.each do |trans|
        puts "- reprocessing #{trans.locale}"
        trans.image_file.file.reprocess!
      end
    end

    # ImageFile.where(visualization_type_id: Visualization::TYPES[:gifographic]).each do |image|
    #   puts "reprocessing image id #{image.id}"
    #   image.file.reprocess!
    # end
  end

  def down
    # do nothing
  end
end
