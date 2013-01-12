class MoveVisualFileToTrans < ActiveRecord::Migration
  def up
    # copy the visual and interactive url data from the visualizations table to the visualization_translations table
    puts "move table records"
    Visualization.all.each do |visual|
      visual.visualization_translations.each do |trans|
        trans.interactive_url = visual.interactive_url_old
        trans.visual_file_name = visual.visual_file_name_old
        trans.visual_content_type = visual.visual_content_type_old
        trans.visual_file_size = visual.visual_file_size_old
        trans.visual_updated_at = visual.visual_updated_at_old
        trans.visual_is_cropped  = visual.visual_is_cropped_old
        trans.save
      end
    end

    # move the visual image files into the new folder tree structure
    # - was /visualization/visuals/id/style/filename
    # - now /visualizations/visual_id/permalink_locale_style.extenstion
    puts "move files"
    FileUtils.mkdir("#{Rails.root}/public/system/visualizations")
    Dir.glob("#{Rails.root}/public/system/visualization/visuals/*").select {|f| File.directory? f}.each do |dir|
      id = dir.split("/").last
      puts "- id = #{id}"
      FileUtils.mkdir("#{Rails.root}/public/system/visualizations/#{id}")
      VisualizationTranslation.where(:visualization_id => id).each do |trans|
        puts "-- locale = #{trans.locale}"
        Dir.glob("#{dir}/*").select {|f| File.directory? f}.each do |style_path|
          style = style_path.split("/").last
          puts "--- style = #{style}"
          Dir.glob("#{style_path}/*").each do |file_path|
            file = file_path.split("/").last
            puts "---- file = #{file}"
            ext = File.extname(file)
            FileUtils.copy(file_path, "#{Rails.root}/public/system/visualizations/#{id}/#{trans.permalink}_#{trans.locale}_#{style}#{ext}")
          end
        end
      end
    end

  end

  def down
    VisualizationTranslation.update_all(
      :interactive_url => nil,
      :visual_file_name => nil,
      :visual_content_type => nil,
      :visual_file_size => nil,
      :visual_updated_at => nil,
      :visual_is_cropped  => nil
    )

    FileUtils.rm_rf("#{Rails.root}/public/system/visualizations")
  end
end
