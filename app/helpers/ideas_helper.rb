module IdeasHelper

	def google_translate_url(text)
		index = I18n.available_locales.index(I18n.locale)
		from_locale = :en
		# locale found in first spot and there is only 1 locale
		if index == 0 && I18n.available_locales.length == 1
			from_locale = I18n.locale
		# locale found in first spot, get locale in 2nd spot
		elsif index == 0 && I18n.available_locales.length > 1
			from_locale = I18n.available_locales[1]
		# locale found not in first spot, get locale in first spot
		elsif index > 0
			from_locale = I18n.available_locales[0]
		end

		"http://translate.google.com/##{from_locale}/#{I18n.locale}/#{text.html_safe}"
	end

  def ideas_votes_cont (obj)
    ip = request.remote_ip
    type = obj.class.name.downcase

    if obj.voted(ip, 'up')
      html = image_tag('thumbs-up-grey.png')
    else
      html = link_to image_tag('thumbs-up.png'), idea_vote_path(:type => type, :votable_id => obj.id, :status => 'up')
    end

    diff = obj.votes_diff
    html += content_tag(:span, diff[:number], :style => "margin:0 5px;color:" + diff[:color])

    if obj.voted(ip, 'down')
      html += image_tag('thumbs-down-grey.png')
    else
      html += link_to image_tag('thumbs-down.png'), idea_vote_path(:type => type, :votable_id => obj.id, :status => 'down')
    end
    html
  end

end
