module ApplicationHelper
	def page_title(page_title)
		title = page_title
		x = nil
		if page_title
      x = content_tag(:div, content_tag(:div, content_tag(:h1, page_title), :class => 'block'), :class => 'page-header')
		end
		return x
	end

  def title(page_title)
    content_for(:title) { page_title }
  end

	def flash_translation(level)
    case level
    when :notice then "alert-info"
    when :success then "alert-success"
    when :error then "alert-error"
    when :alert then "alert-error"
    end
  end

	def current_url
		"#{request.protocol}#{request.host_with_port}#{request.fullpath}"
	end

	def full_url(path)
		"#{request.protocol}#{request.host_with_port}#{path}"
	end

	# from http://www.kensodev.com/2012/03/06/better-simple_format-for-rails-3-x-projects/
	# same as simple_format except it does not wrap all text in p tags
	def simple_format_no_tags(text, html_options = {}, options = {})
		text = '' if text.nil?
		text = smart_truncate(text, options[:truncate]) if options[:truncate].present?
		text = sanitize(text) unless options[:sanitize] == false
		text = text.to_str
		text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
#		text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
		text.html_safe
	end

end
