####################
# /visualizations/....
# this controller is the public view to the visuals
####################
class VisualsController < ApplicationController
  before_filter(:only => [:promote, :unpromote]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:visual_promotion])
  end

  def ajax
    respond_to do |format|
      format.js {
        vis_w = 270
        sidebar_w = params[:sidebar] == "true" ? vis_w : 0
        menu_w = 200
        max = params[:max].nil? ? 4 : params[:max].to_i
        min = 2
        screen_w = params[:screen_w].nil? ? 4 * vis_w : params[:screen_w].to_i
        number = (screen_w - menu_w - sidebar_w) / vis_w
        if number > max
          number = max
        elsif number < min
          number = min
        end
        number *= 2
        
        visualizations = Visualization.published

        # if org is provided and user is in org, show unpublished
        if params[:org].present?
		      @organization = Organization.where(:organization_translations => {:permalink => params[:org]}).with_name.first

		      if @organization
Rails.logger.debug "****************** @org exists"
			      @user_in_org = false
			      if user_signed_in? && current_user.organization_ids.index(@organization.id)
Rails.logger.debug "****************** user is in org"
				      @user_in_org = true
			        visualizations = Visualization
			      end
          end          
        end

        @visualizations = process_visualization_querystring(visualizations.page(params[:page]).per(number))

        @ajax_call = true
        render 'shared/visuals_index'
      }
    end
  end

  def index
    @param_options[:format] = :js
    @param_options[:max] = 5
    gon.ajax_path = visuals_ajax_path(@param_options)

    set_visualization_view_type # in app controller

    respond_to do |format|
      format.atom { @visualizations = Visualization.published.recent }
      format.html
    end
	end

  # this is so crawlers can find all reocrds since they are loaded via ajax
  def all
    @visualizations = Visualization.published.recent
	  respond_to do |format|
	    format.html
	    format.json { render json: @visalizations }
	  end
  end

  def show
    @visualization = Visualization.published.find_by_permalink(params[:id])
    gon.highlight_first_form_field = false

   #gon.current_content = {:type => 'visual', :id => @visualization.id}

		if @visualization
			if @visualization.visualization_type_id == Visualization::TYPES[:interactive] && params[:view] == 'interactive'
			  @view_type = 'shared/visuals_show_interactive'
				gon.show_interactive = true
			else
			  @view_type = 'shared/visuals_show'
			end

			gon.show_fb_comments = true
      gon.show_fb_like = true

      # if from_embed in url, set gon so large image loads automatically
      if params[:from_embed] && (@visualization.visualization_type_id == Visualization::TYPES[:infographic] ||
                                 @visualization.visualization_type_id == Visualization::TYPES[:fact])
        gon.trigger_fancybox_large_image = true
      end

			respond_to do |format|
			  format.html
			  format.json { render json: @visualization }
			end

      # record the view count
      impressionist(@visualization) if !(@visualization.visualization_type_id == Visualization::TYPES[:interactive] && params[:view] == 'interactive')

		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
		end
  end

  def fb_like
    visualization = Visualization.published.find_by_permalink(params[:id])
    visualization.process_like if visualization.present?  
    render :nothing => true
  end

  def vote
    if !user_signed_in?
      redirect_to new_user_session_path
      return
    end

    success = true
    
		redirect_path = if request.env["HTTP_REFERER"]
	    :back
		else
	    root_path
		end

    if ['down', 'up'].include?(params[:status])
      visualization = Visualization.published.find_by_permalink(params[:id])

      if !visualization.blank?
        visualization.process_vote(current_user, params[:status])
      else
        success = false
      end
    else
      success = false
    end
    
    respond_to do |format|
      format.html{ redirect_to redirect_path}
      format.js {render json: {'status' => success ? 'success' : 'fail'} }
    end
    
  end

  def next
    next_previous('next')
  end

  def previous
    next_previous('previous')
  end

	def comment_notification
    visualization = Visualization.published.find_by_permalink(params[:id])
		if visualization
      # update the fb_count value
      visualization.fb_count = visualization.fb_count + 1
      visualization.save

      # notify org users if want notification
			message = Message.new
			I18n.available_locales.each do |locale|
				message.bcc = Notification.visual_comment(visualization.organization_id, locale)
				if message.bcc && !message.bcc.empty?
					message.locale = locale
          title = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first.title
          permalink = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first.permalink
					message.subject = I18n.t("mailer.notification.visualization_comment.subject",
						:title => title, :locale => locale)
					message.message = I18n.t("mailer.notification.visualization_comment.message", :locale => locale)
					message.url_id = permalink
					NotificationMailer.visualization_comment(message).deliver
				end
			end

			render :text => "true"
			return false
		end
		render :text => "false"
		return false
	end


  def promote
    visualization = Visualization.published.find_by_permalink(params[:id])
    if visualization
      if !visualization.is_promoted
        visualization.is_promoted = true
        visualization.save
        flash[:notice] = t('app.msgs.visual_promoted')

        # notify org users
			  message = Message.new
        users = User.organization_users(visualization.organization_id)
			  I18n.available_locales.each do |locale|
				  message.bcc = users.select{|x| x.notification_language == locale.to_s}.map{|x| x.email}
				  if message.bcc.length > 0
					  message.locale = locale
            trans = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first
					  message.subject = I18n.t("mailer.notification.visualization_promoted.subject", :title => trans.title, :locale => locale)
					  message.message = I18n.t("mailer.notification.visualization_promoted.message", :locale => locale)
					  message.url_id = trans.permalink
					  NotificationMailer.visualization_promoted(message).deliver
				  end
			  end

      end
      redirect_to visualization_path(visualization.permalink, @param_options)
    else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
    end
  end

  def unpromote
    visualization = Visualization.published.find_by_permalink(params[:id])
    if visualization
      if visualization.is_promoted
        visualization.is_promoted = false
        visualization.save
        flash[:notice] = t('app.msgs.visual_unpromoted')
      end
      redirect_to visualization_path(visualization.permalink, @param_options)
    else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
    end
  end
protected

  def next_previous(type)
    if params[:org].present?
      @organization = Organization.where(:organization_translations => {:permalink => params[:org]}).with_name.first
    end

		# get a list of visual ids in correct order
    visualizations = process_visualization_querystring(Visualization.select("visualizations.id").published.recent)
    
    # get the visual that was showing
    visualization = Visualization.published.find_by_permalink(params[:id])
		record_id = nil

		if !visualizations.blank? && !visualization.blank?
			index = visualizations.index{|x| x.id == visualization.id}
      if type == 'next'
  			if index
  				if index == visualizations.length-1
  					record_id = visualizations[0].id
  				else
  					record_id = visualizations[index+1].id
  				end
  			else
  				record_id = visualizations[0].id
  			end
  		elsif type == 'previous'
				if index
					if index == 0
						record_id = visualizations[visualizations.length-1].id
					else
						record_id = visualizations[index-1].id
					end
				else
					record_id = visualizations[0].id
				end
			end

			if record_id
  			# get the next record
  			visual = Visualization.published.find_by_id(record_id)

  			if visual
  			  # found next record, go to it
          redirect_to visualization_path(visual.permalink, @param_options)
          return
  	    end
      end
    end

		# if get here, then next record was not found
    redirect_to(visuals_path, :alert => t("app.common.page_not_found"))
    return
  end
end
