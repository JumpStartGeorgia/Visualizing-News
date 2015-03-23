module CopyImages
  TYPE = {thumbnail: 1, fact: 2}

  def self.thumbnails_before_date(date='2014-01-01')
    # get visual ids
    copy(TYPE[:thumbnail], "thumbnails_before_#{date}", Visualization.where('published_date < ?', date).map{|x| x.id})
  end

  def self.thumbnails_after_date(date='2014-01-01')
    copy(TYPE[:thumbnail], "thumbnails_after_#{date}", Visualization.where('published_date >= ?', date).map{|x| x.id})
  end


  def self.facts_before_date(date='2014-01-01')
    # get visual ids
    copy(TYPE[:thumbnail], "facts_before_#{date}", Visualization.where('visualization_type_id = 3 and published_date < ?', date).map{|x| x.id})
  end

  def self.facts_after_date(date='2014-01-01')
    copy(TYPE[:thumbnail], "facts_after_#{date}", Visualization.where('visualization_type_id = 3 and published_date >= ?', date).map{|x| x.id})
  end

  def self.copy(type, folder_name, ids)
    image_path = ''
    if type == TYPE[:thumbnail]
      image_path = "#{Rails.public_path}/system/visualizations/[id]/image/*_thumb.*"
    else
      image_path = "#{Rails.public_path}/system/visualizations/[id]/image/*_original.*"
    end      

    if ids.present?
      puts "copying images for #{ids.length} records"

      # create folders
      folder = "#{Rails.root}/tmp/#{folder_name}"
      FileUtils.mkpath(folder) if !File.exists?(folder)
      puts "images are at #{folder}"

      # for each id, create folder and copy thumbnail images  
      ids.each do |id|
        id_folder = "#{folder}/#{id}"
        img_path = image_path.gsub('[id]', id.to_s)
        Dir.glob(img_path).each do |img|
          FileUtils.mkpath(id_folder) if !File.exists?(id_folder)
          file_name = File.basename(img)
          FileUtils.cp img, "#{id_folder}/#{file_name}"
        end
      end
    end
    return nil
  end




end