class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :set_locale
#	before_filter :is_browser_supported?
	before_filter :preload_global_variables
	before_filter :initialize_gon
	before_filter :create_querystring_hash
	after_filter :store_location

	layout :layout_by_resource

	unless Rails.application.config.consider_all_requests_local
		rescue_from Exception,
		            :with => :render_error
		rescue_from ActiveRecord::RecordNotFound,
		            :with => :render_not_found
		rescue_from ActionController::RoutingError,
		            :with => :render_not_found
		rescue_from ActionController::UnknownController,
		            :with => :render_not_found
		rescue_from ActionController::UnknownAction,
		            :with => :render_not_found

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
	end

	Browser = Struct.new(:browser, :version)
	SUPPORTED_BROWSERS = [
		Browser.new("Chrome", "15.0"),
		Browser.new("Safari", "4.0.2"),
		Browser.new("Firefox", "10.0.2"),
		Browser.new("Internet Explorer", "9.0"),
		Browser.new("Opera", "11.0")
	]

	def is_browser_supported?
		user_agent = UserAgent.parse(request.user_agent)
logger.debug "////////////////////////// BROWSER = #{user_agent}"
		if SUPPORTED_BROWSERS.any? { |browser| user_agent < browser }
			# browser not supported
logger.debug "////////////////////////// BROWSER NOT SUPPORTED"
			render "layouts/unsupported_browser", :layout => false
		end
	end


	def set_locale
    if params[:locale] and I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
	end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

	def preload_global_variables
		@categories = Category.sorted
		@visuals_filter_type_selection = I18n.t('filters.visuals.type.all')
		@visuals_filter_type_icon = 'all'
		@visuals_filter_view_selection = I18n.t('filters.visuals.view.grid')
		@ideas_filter_view_selection = I18n.t('filters.ideas.view.grid')
		@ideas_filter_filter_selection = I18n.t('filters.ideas.filter.all')

	  @idea_statuses = IdeaStatus.with_translations(I18n.locale).sorted
    @idea = Idea.new
	  @idea.idea_categories.build


		@fb_app_id = ENV['VISUALIZING_NEWS_FACEBOOK_APP_ID']

    # reset language param if it is the current locale
    params[:language] = nil if params[:language].present? && params[:language] == I18n.locale.to_s
    @language = params[:language].present? && I18n.available_locales.include?(params[:language].to_sym) ? params[:language] : I18n.locale.to_s

    # reset category if it is the all option, which is the default
    params[:category] = nil if params[:category] == I18n.t('filters.category_default')

	end

	def initialize_gon
		gon.set = true
		gon.highlight_first_form_field = true
    gon.user_signed_in = user_signed_in?
		gon.placeholder = t('app.common.placeholder')
		gon.visual_comment_notification_url = visual_comment_notification_path(gon.placeholder)
		gon.idea_comment_notification_url = idea_comment_notification_path(gon.placeholder)
		gon.visual_fb_like_url = visual_fb_like_path(gon.placeholder)
		gon.idea_fb_like_url = idea_fb_like_path(gon.placeholder)
		gon.fb_app_id = ENV['VISUALIZING_NEWS_FACEBOOK_APP_ID']
		gon.thumbnail_size = 230
		gon.id_top = t('app.common.top_ideas').gsub(" ", "_").downcase
		gon.id_new = t('app.common.new_ideas').gsub(" ", "_").downcase
		gon.id_in_progress = t('app.common.in_progress').gsub(" ", "_").downcase
		gon.id_realized = t('app.common.realized').gsub(" ", "_").downcase
		@id_top = gon.id_top
		@id_new = gon.id_new
		@id_in_progress = gon.id_in_progress
		@id_realized = gon.id_realized

    idea_status_published = @idea_statuses.select{|x| x.is_published}
		gon.idea_status_id_published = @idea_statuses.select{|x| x.is_published}.first.id.to_s if idea_status_published.present?
	end

	# after user logs in go back to the last page or go to root page
	def after_sign_in_path_for(resource)
		request.env['omniauth.origin'] || session[:previous_urls].last || root_path
	end

  def valid_role?(role)
    redirect_to root_path(:locale => I18n.locale), :notice => t('app.msgs.not_authorized') if !current_user || !current_user.role?(role)
  end

  def assigned_to_org?(organization_permalink)
    org_id = OrganizationTranslation.get_org_id(organization_permalink)
    redirect_to root_path(:locale => I18n.locale), :notice => t('app.msgs.not_authorized') if !current_user || !current_user.organization_ids.index(org_id)
  end

	# store the current path so after login, can go back
	def store_location
		session[:previous_urls] ||= []
		# only record path if page is not for users (sign in, sign up, etc) and not for reporting problems
		if session[:previous_urls].first != request.fullpath && 
        params[:format] != 'js' && params[:format] != 'json' && 
        request.fullpath.index("/users/").nil? && request.fullpath.index("/report/").nil?

			session[:previous_urls].unshift request.fullpath
		end
		session[:previous_urls].pop if session[:previous_urls].count > 1
	end


	DEVISE_CONTROLLERS = ['devise/sessions', 'devise/registrations', 'devise/passwords']
	def layout_by_resource
    if !DEVISE_CONTROLLERS.index(params[:controller]).nil?
      "fancybox"
		elsif params[:view] == 'interactive'
			"interactive"
    else
      "application"
    end
  end

  #######################
  def create_querystring_hash
    @param_options = Hash.new
    url = URI.parse(request.fullpath)
    @param_options = CGI.parse(url.query).inject({}) { |h, (k, v)| h[k] = v.first; h } if url.query

    # if page in params, remove it
    @param_options.delete('page')

    # if language in params and is equal to I18n.locale, remove it
    @param_options.delete('language') if @param_options['language'].present? && @param_options['language'] == I18n.locale.to_s

    # if category is the all category, remove it for this is the default 
    @param_options.delete('category') if @param_options['category'] == I18n.t('filters.category_default')

    # if user_id in params, make sure it is in this hash tag
    if params[:user_id] && @param_options.keys.index('user_id').nil?
      @param_options['user_id'] = params[:user_id]
    end
  end

  def set_visualization_view_type
    # language
    if params[:language].present? && I18n.available_locales.include?(params[:language].to_sym)
      @visuals_filter_language_selection = I18n.t("app.language.#{params[:language]}")
      @visuals_filter_language_icon = params[:language]
    else
      @visuals_filter_language_selection = I18n.t("app.language.#{I18n.locale}")
      @visuals_filter_language_icon = I18n.locale.to_s
    end

    # view type
	  if params[:view] && params[:view] == 'list'
	    @view_type = 'shared/visuals_list'
			@visuals_filter_view_selection = I18n.t('filters.visuals.view.list')
			@visuals_filter_view_icon = 'list'
	  else
	    @view_type = 'shared/visuals_grid'
			@visuals_filter_view_selection = I18n.t('filters.visuals.view.grid')
			@visuals_filter_view_icon = 'grid'
	  end

    # sort type
		if params[:organize] && I18n.t('filters.visuals.organize').keys.map{|x| x.to_s}.include?(params[:organize])
			@visuals_filter_organize_selection = I18n.t("filters.visuals.organize.#{params[:organize]}")
			@visuals_filter_organize_icon = params[:organize]
    else
      # if not set, default to recent
			@visuals_filter_organize_selection = I18n.t("filters.visuals.organize.recent")
			@visuals_filter_organize_icon = 'recent'
		end

    # type
		if params[:type] && I18n.t('filters.visuals.type').keys.map{|x| x.to_s}.include?(params[:type])
			@visuals_filter_type_selection = I18n.t("filters.visuals.type.#{params[:type]}")
			@visuals_filter_type_icon = params[:type]
		else
			@visuals_filter_type_icon = 'all'
		end

	#	params[:category] = I18n.t('filters.category_default') if !params[:category].present?

  end

  ## visual querystring
  def process_visualization_querystring(visual_objects)

    set_visualization_view_type

    # language
    if params[:language].present? && I18n.available_locales.include?(params[:language].to_sym)
      visual_objects = visual_objects.by_language(params[:language])
    else
      # default to current locale
      visual_objects = visual_objects.by_language
    end

    # promoted visuals
    if params[:promoted] == "true"
		  visual_objects = visual_objects.promoted
    end

    # type of visuals
		if params[:type] && I18n.t('filters.visuals.type').keys.map{|x| x.to_s}.include?(params[:type])
      if params[:type] == 'not_published'
			  visual_objects = visual_objects.unpublished
      elsif params[:type] == 'not_promoted'
			  visual_objects = visual_objects.not_promoted
      else
			  type_id = Visualization.type_id(params[:type])
			  visual_objects = visual_objects.by_type(type_id) if type_id
      end
		  @visuals_filter_type_selection = I18n.t("filters.visuals.type.#{params[:type]}")
		  @visuals_filter_type_icon = params[:type]
		else
			@visuals_filter_type_icon = 'all'
      params[:type] = nil
		end

    # sort order
		if params[:organize] && I18n.t('filters.visuals.organize').keys.map{|x| x.to_s}.include?(params[:organize])
      case params[:organize]
        when 'recent'
    			visual_objects = visual_objects.recent
          params[:organize] = nil
        when 'likes'
    			visual_objects = visual_objects.likes
        when 'views'
    			visual_objects = visual_objects.views
      end
			@visuals_filter_organize_selection = I18n.t("filters.visuals.organize.#{params[:organize]}")
    else
      # if not set, default to recent
			visual_objects = visual_objects.recent
			@visuals_filter_organize_selection = I18n.t("filters.visuals.organize.recent")
      params[:organize] = nil
		end

    # category
		if params[:category] && params[:category] != I18n.t('filters.category_default')
      index = @categories.index{|x| x.permalink == params[:category]}
			visual_objects = visual_objects.by_category(@categories[index].id) if index
    else
      params[:category] = nil
		end

    # search
		if params[:q]
			visual_objects = visual_objects.search_for(params[:q])
		end

    # organizations
    if params[:org] && @organization
			visual_objects = visual_objects.by_organization(@organization.id)
    else
      params[:org] = nil
    end

		return visual_objects
  end

  ## idea querystring
  def set_idea_view_type
	  if params[:view] && params[:view] == 'list'
	    @view_type = 'shared/ideas_list'
			@ideas_filter_view_selection = I18n.t('filters.ideas.view.list')
			@ideas_filter_view_icon = 'list'
	  else
	    @view_type = 'shared/ideas_grid'
			@ideas_filter_view_selection = I18n.t('filters.ideas.view.grid')
			@ideas_filter_view_icon = 'grid'
	  end

		if params[:filter] && I18n.t('filters.ideas.filter').keys.map{|x| x.to_s}.include?(params[:filter])
			@ideas_filter_filter_selection = I18n.t("filters.ideas.filter.#{params[:filter]}")
			@ideas_filter_filter_icon = params[:filter]
    else
      # if not set, default to all (no filter needed)
			@ideas_filter_filter_selection = I18n.t("filters.ideas.filter.all")
			@ideas_filter_filter_icon = 'all'
		end

		if params[:organize] && I18n.t('filters.ideas.organize').keys.map{|x| x.to_s}.include?(params[:organize])
			@ideas_filter_organize_selection = I18n.t("filters.ideas.organize.#{params[:organize]}")
			@ideas_filter_organize_icon = params[:organize]
    else
      # if not set, default to recent
			@ideas_filter_organize_selection = I18n.t("filters.ideas.organize.recent")
			@ideas_filter_organize_icon = 'recent'
		end  

		params[:category] = I18n.t('filters.category_default') if !params[:category].present?

  end


  def process_idea_querystring(idea_objects)

    set_idea_view_type

		if params[:filter] && I18n.t('filters.ideas.filter').keys.map{|x| x.to_s}.include?(params[:filter])
      case params[:filter]
        when 'all'
    			# do nothing
        when 'not_selected'
    			idea_objects = idea_objects.not_selected(current_user)
        when 'in_progress'
    			idea_objects = idea_objects.in_progress(current_user)
        when 'completed'
    			idea_objects = idea_objects.completed(current_user)
      end
			@ideas_filter_filter_selection = I18n.t("filters.ideas.filter.#{params[:filter]}")
    else
      # if not set, default to all (no filter needed)
			@ideas_filter_filter_selection = I18n.t("filters.ideas.filter.all")
		end

		if params[:organize] && I18n.t('filters.ideas.organize').keys.map{|x| x.to_s}.include?(params[:organize])
      case params[:organize]
        when 'recent'
    			idea_objects = idea_objects.recent
        when 'likes'
    			idea_objects = idea_objects.likes
        when 'views'
    			idea_objects = idea_objects.views
      end
			@ideas_filter_organize_selection = I18n.t("filters.ideas.organize.#{params[:organize]}")
    else
      # if not set, default to recent
			idea_objects = idea_objects.recent
			@ideas_filter_organize_selection = I18n.t("filters.ideas.organize.recent")
		end

		if params[:category] && params[:category] != I18n.t('filters.category_default')
      index = @categories.index{|x| x.permalink == params[:category]}
			idea_objects = idea_objects.by_category(@categories[index].id) if index
		end

		if params[:user_id]
			idea_objects = idea_objects.by_user(params[:user_id])
		end

		if params[:q]
			idea_objects = idea_objects.search_for(params[:q])
		end

		return idea_objects
  end

  #######################
	def render_not_found(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/404.html", :status => 404
	end

	def render_error(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/500.html", :status => 500
	end

end
