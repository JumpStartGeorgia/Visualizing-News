module ApplicationHelper
	require 'utf8_converter'
	def page_title(page_title)
		title(page_title)
		x = nil

		if page_title
      h1_content = content_tag(:h1, page_title)
      if content_for?(:title_image)
        h1_content = content_tag(:h1) do
          tag('img', {:src => content_for(:title_image), :style => 'vertical-align: middle; margin-right: 5px;'}) + 
          content_tag(:span, page_title)
        end
      elsif content_for(:title_after)
        h1_content = content_tag(:h1) do
          content_tag(:span, page_title) + content_tag(:span, content_for(:title_after), :class => 'title_after')
        end
      end

      x = content_tag(:div, content_tag(:div, h1_content, :class => 'block'), :class => 'page-header')
		end
		return x
	end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def title_image(image_url)
    content_for(:title_image) { image_url }
  end

  def title_after(text)
    content_for(:title_after) { text }
  end

	def flash_translation(level)
    case level
    when :notice then "alert-info"
    when :success then "alert-success"
    when :error then "alert-error"
    when :alert then "alert-error"
    end
  end

	def current_url(no_view_param=false)
		x = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
		if no_view_param && request.fullpath.index("?") && request.fullpath.index("view=")
			u = URI::parse(request.fullpath)
			p = CGI::parse(u.query)
			p.delete("view")
			if p.empty?
				x = "#{request.protocol}#{request.host_with_port}#{u.path}"
			else
				# rebuild querystring
				q = []
				p.keys.each do |key|
					q << "#{key}=#{p[key].first}"
				end
				x = "#{request.protocol}#{request.host_with_port}#{u.path}?#{q.join("&")}"
			end
		end
		return x
	end

	def full_url(path)
		"#{request.protocol}#{request.host_with_port}#{path}"
	end

	def permalink(text)
    Utf8Converter.convert_ka_to_en(text.downcase.gsub(" ","_").gsub("/","_").gsub("__","_").gsub("__","_"))
	end

	# since the url contains english or georgian text, the text must be updated to the correct language
	# for the language switcher link to work
	# - only applies to organizations and visualizations
	def generate_language_switcher_link(locale)
		vis = nil
		org = nil

		if @organization
			org = OrganizationTranslation.where(:locale => locale, :organization_id => @organization.id)
		end

		if @visualization
			vis = VisualizationTranslation.where(:locale => locale, :visualization_id => @visualization.id)
		end

    category = nil
    if params[:category]
      category = params[:category]
      index = @categories.index{|x| x.permalink == params[:category]}
      if index
        category = CategoryTranslation.where(:locale => locale, :category_id => @categories[index].id)
        if !category.blank?
          category = category.first.permalink
        end
      end
    end

		if !vis.blank? && !org.blank?
			link_to t("app.language.#{locale}"), params.merge(:locale => locale,
				:organization_id => org.first.permalink,
				:id => vis.first.permalink,
        :category => category
			)
		elsif !vis.blank?
			link_to t("app.language.#{locale}"), params.merge(:locale => locale,
				:id => vis.first.permalink,
        :category => category)
		elsif !org.blank?
			link_to t("app.language.#{locale}"), params.merge(:locale => locale,
				:id => org.first.permalink,
        :category => category)
		else
			link_to t("app.language.#{locale}"), params.merge(:locale => locale,
        :category => category)
		end
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

  def assign_active_class(path)
    is_current_section(path) ? " active" : ""
  end

  # determine if the path is contained in the current url
  # - if menu item path is /news we want /news/3 to be a match
  def is_current_section(path)
    request.fullpath.start_with?(path)
  end

  def remove_unwanted_params(params, remove_filters = false)
    p = params.blank? ? {} : params.clone
    js_params = ['format', 'max', 'sidebar', 'screen_w']
    filter_params = ['user_id', 'q', 'org']
    params = remove_filters ? js_params.concat(filter_params) : js_params
    params.each do |param|
      p.delete_if{|k,v| k.to_s == param}
    end
    return p
  end
end
