module UpdateFacebookLikes
	require 'net/http'
  require 'net/https'
  require "uri"

  def self.host_url
    host = "http://feradi.info"
=begin
    if Rails.env.staging?
      host = "http://dev-feradi.jumpstart.ge"
    elsif Rails.env.development?
      host = "http://localhost:3000"
    end
=end
    return host
  end

  # get likes for home page
  # - if fb not find url, it defaults to root url
  def self.get_root_count
    host = host_url
    root_count = {'ka' => 0, 'en' => 0}
    root_count.keys.each do |locale|
      uri = URI.parse("https://graph.facebook.com/?ids=#{host}/#{locale}")
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true 
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.body.present?
        json = JSON.parse(response.body)
        root_count[locale] = json.first[1]["shares"] if json.present? && json.first.present?
      end
    end

    return root_count
  end  
    

  def self.visuals
    start = Time.now
    puts "***************************************"
    puts "update visuals start"

    host = host_url
    root_count = get_root_count

    puts "host = #{host}"
    puts "root_count = #{root_count}"

    Visualization.published.each do |visual|
      puts "*************"
      puts "visual = #{visual.title}"
      puts "fb_likes was #{visual.fb_likes}"
      puts "overall votes was #{visual.overall_votes}"
      count = {'ka' => 0, 'en' => 0}
      sum = 0
      visual.visualization_translations.each do |trans|
		    uri = URI.parse("https://graph.facebook.com/?ids=#{host}/#{trans.locale}/visualizations/#{trans.permalink}")
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true 
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        x = 0
        if response.body.present?
puts "response = #{JSON.parse(response.body)}"
          json = JSON.parse(response.body)
          x = json.first[1]["shares"] if json.present? && json.first.present?
          # if the count is the same as the root count, reset to 0
          x = 0 if x == root_count[trans.locale] || !x.present?
        end
        count[trans.locale] = x
      end
      
      puts "fb count = #{count}"

      # if sum(count) != fb_likes, then update value and overall likes
      sum = count.values.inject(:+) if count.present?
      puts "sum = #{sum}"
      if sum < visual.fb_likes
        puts '- new count < old count, decreasing'
        visual.overall_votes -= visual.fb_likes - sum
      elsif sum > visual.fb_likes
        puts '- new count > old count, increasing'
        visual.overall_votes += sum - visual.fb_likes 
      end
      visual.fb_likes = sum
      puts "overall votes now #{visual.overall_votes}"
      puts "fb_likes now #{visual.fb_likes}"
      visual.save

    end

    puts "*** total time = #{Time.now - start} seconds"
    puts "update visuals end"
    puts "***************************************"
  end


  def self.ideas
    start = Time.now
    puts "***************************************"
    puts "update ideas start"

    host = host_url
    root_count = get_root_count

    puts "host = #{host}"
    puts "root_count = #{root_count}"

    Idea.public_only.each do |idea|
      puts "*************"
      puts "idea = #{idea.id}"
      puts "fb_likes was #{idea.fb_likes}"
      puts "overall votes was #{idea.overall_votes}"
      sum = 0
      count = {'ka' => 0, 'en' => 0}

      I18n.available_locales.each do |locale|
		    uri = URI.parse("https://graph.facebook.com/?ids=#{host}/#{locale}/ideas/#{idea.id}")
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true 
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        x = 0
        if response.body.present?
puts "response = #{JSON.parse(response.body)}"
          json = JSON.parse(response.body)
          x = json.first[1]["shares"] if json.present? && json.first.present?
          # if the count is the same as the root count, reset to 0
          x = 0 if x == root_count[locale.to_s] || !x.present?
        end
        count[locale.to_s] = x
      end
      
      
      puts "fb count = #{count}"

      # if sum(count) != fb_likes, then update value and overall likes
      sum = count.values.inject(:+) if count.present?
      puts "sum = #{sum}"
      if sum < idea.fb_likes
        puts '- new count < old count, decreasing'
        idea.overall_votes -= idea.fb_likes - sum
      elsif sum > idea.fb_likes
        puts '- new count > old count, increasing'
        idea.overall_votes += sum - idea.fb_likes 
      end
      idea.fb_likes = sum
      puts "overall votes now #{idea.overall_votes}"
      puts "fb_likes now #{idea.fb_likes}"
      idea.save

    end

    puts "*** total time = #{Time.now - start} seconds"
    puts "update ideas end"
    puts "***************************************"
  end
end

