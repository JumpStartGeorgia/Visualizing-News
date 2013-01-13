class MoveDatasetData < ActiveRecord::Migration
  def up
    # copy the dataset records to upload files
    puts "move table records"
    Visualization.all.each do |visual|
			if !visual.dataset_file_name_old.blank?
		    visual.visualization_translations.each do |trans|
					trans.upload_files.create(
						:type_id => UploadFile::TYPES[:dataset],
				    :upload_file_name => visual.dataset_file_name_old,
				    :upload_content_type => visual.dataset_content_type_old,
				    :upload_file_size => visual.dataset_file_size_old,
				    :upload_updated_at => visual.dataset_updated_at_old
					)
		    end
	    end
    end

    # move the visual image files into the new folder tree structure
    # - was /visualization/datasets/id/style/filename
    # - now /system/visualizations/:visual_id/:type/:locale/:filename
    puts "move files"
    Dir.glob("#{Rails.root}/public/system/visualization/datasets/*").select {|f| File.directory? f}.each do |dir|
      id = dir.split("/").last
      puts "- id = #{id}"
      VisualizationTranslation.where(:visualization_id => id).each do |trans|
        puts "-- locale = #{trans.locale}"
	      FileUtils.mkpath("#{Rails.root}/public/system/visualizations/#{id}/dataset/#{trans.locale}")
        Dir.glob("#{dir}/*").each do |file_path|
          file = file_path.split("/").last
          puts "---- file = #{file}"
          ext = File.extname(file)
          FileUtils.copy(file_path, "#{Rails.root}/public/system/visualizations/#{trans.visualization_id}/dataset/#{trans.locale}/")
        end
      end
    end
  end

  def down
		UploadFile.where(:type_id => UploadFile::TYPES[:dataset]).delete_all

    Dir.glob("#{Rails.root}/public/system/visualizations/*").select {|f| File.directory? f}.each do |dir|
      puts "- directory = #{dir.split("/").last}"
			Dir.glob("#{dir}/*").select {|f| File.directory? f}.each do |dir2|
	      puts "-- subdirectory = #{dir2.split("/").last}"
        folder = dir2.split("/").last

				if folder == "dataset"
		      puts "--- found dataset, removing"
			    FileUtils.rm_rf("#{dir2}")
				end
			end
		end
  end
end
