# encoding: utf-8
module Utf8Converter

	def self.geo
		['ა','ბ','გ','დ','ე','ვ','ზ','თ','ი','კ','ლ','მ','ნ','ო','პ','ჟ',
		'რ','ს','ტ','უ','ფ','ქ','ღ','ყ','შ','ჩ','ც','ძ','წ','ჭ','ხ','ჯ','ჰ']
	end

	def self.eng
		['a','b','g','d','e','v','z','t','i','k','l','m','n','o','p','zh','r',
		's','t','u','p','k','gh','q','sh','ch','ts','dz','ts','ch','kh','dj','h']
	end

	# determine if the text contains georgian characters
	# - assuming if first character is geo, than all is geo
	def self.is_geo?(text)
		is_geo = false
		if text
			is_geo = true if !geo.index(text[0]).nil?
		end
		return is_geo
	end

  def self.convert_ka_to_en (text)
    geo.each_with_index do |v, i|
      text.gsub! /#{v}/, eng[i]
    end
    return text
  end

end
