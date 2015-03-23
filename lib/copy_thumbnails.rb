module CopyThumbnails

  def self.copy_before_date(date='2014-01-01')
    # get visual ids
    copy("thumbnails_before_#{date}", Visualization.where('published_date < ?', date).map{|x| x.id})
  end

  def self.copy_after_date(date='2014-01-01')
    copy("thumbnails_after_#{date}", Visualization.where(published_date >= ?', date).map{|x| x.id})
  end


  def self.copy(folder_name, ids)
    image_path = "#{Rails.root}/public/system/visualizations/[id]/image/*_thumb.*"

    if ids.present?
      puts "copying thumbnails for #{ids.length} records"

      # create folders
      folder = "#{Rails.root}/tmp/#{folder_name}"
      FileUtils.mkpath(folder) if !File.exists?(folder)
      puts "thumbnails are at #{folder}"

      # for each id, create folder and copy thumbnail images  
      ids.each do |id|
        id_folder = "#{folder}/#{id}"
        img_path = image_path.gsub('[id]', id.to_s)
        FileUtils.mkpath(id_folder) if !File.exists?(id_folder)
        Dir.glob(img_path).each do |img|
          file_name = File.basename(img)
          FileUtils.cp img, "#{id_folder}/#{file_name}"
        end
      end
    end
    return nil
  end
end