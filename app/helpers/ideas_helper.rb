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

  # options = [{key, value}]
  def merge_idea_params(options)
    p = @param_options.clone
    options.each do |option|
      if !option[:key].blank? && !option[:value].blank?
        p[option[:key].to_s] = option[:value]
      end
    end
    return p 
  end


end
