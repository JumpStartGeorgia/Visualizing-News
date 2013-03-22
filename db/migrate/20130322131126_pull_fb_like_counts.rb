class PullFbLikeCounts < ActiveRecord::Migration
  def up

  	require 'net/http'
    require 'net/https'
    require "uri"

    host = "http://feradi.info"
=begin
    if Rails.env.staging?
      host = "http://dev-feradi.jumpstart.ge"
    elsif Rails.env.development?
      host = "http://localhost:3000"
    end
=end
=begin
    # get likes for home page
    # - if fb not find url, it defaults to root url
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
  
    puts "*************"
    puts "root count = #{root_count}"
    puts "*************"

    Visualization.published.limit(10).each do |visual|
      puts "*************"
      puts "visual = #{visual.title}"
      count = []
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
          x = 0 if x == root_count[trans.locale]
        end
        count << x 

      end

      
      puts "fb count = #{count}"

    end
=end
  end

  def down
    # do nothing
  end
end
