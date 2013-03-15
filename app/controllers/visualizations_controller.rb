class VisualizationsController < ApplicationController
  before_filter(:only => [:promote, :unpromote]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:visual_promotion])
  end
  before_filter(:only => [:new, :edit, :create, :update, :destroy]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:visual_promotion])
  end
  before_filter(:only => [:new, :edit, :create, :update, :destroy]) do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:organization])
  end

  require 'screenshot'

  ##########################
  ## public pages
  #########################
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
	      if params[:organization].present? && @organization && @user_in_org
	        visualizations = Visualization
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
    gon.ajax_path = ajax_visualizations_path(@param_options)

    set_visualization_view_type # in app controller

    respond_to do |format|
      format.atom { @visualizations = Visualization.published.recent }
      format.html
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

      # if from_embed in url, set gon so large image loads automatically
      if params[:from_embed] && @visualization.visualization_type_id == Visualization::TYPES[:infographic]
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

=begin #old
  def show
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.find_by_permalink(params[:id])
    gon.highlight_first_form_field = false

		if @visualization
			if @visualization.visualization_type_id == Visualization::TYPES[:interactive] && params[:view] == 'interactive'
			  @view_type = 'shared/visuals_show_interactive'
				gon.show_interactive = true
			else
			  @view_type = 'shared/visuals_show'
			end

			respond_to do |format|
			  format.html
			  format.json { render json: @visualization }
			end
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
		end
  end
=end


  ##########################
  ## restricted pages
  #########################
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

  def new
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.new
	  # create the translation object for however many locales there are
	  # so the form will properly create all of the nested form fields
		if @visualization.visualization_translations.length != I18n.available_locales.length
			I18n.available_locales.each do |locale|
				@visualization.visualization_translations.build(:locale => locale.to_s) if !@visualization.visualization_translations.index{|x| x.locale == locale.to_s}
				# add image file record
				@visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first.build_image_file
			end
		end
		gon.edit_visualization = true

		# initialize to be infographic
		@visualization.visualization_type_id = Visualization::TYPES[:infographic]
		gon.visualization_type = @visualization.visualization_type_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @visualization }
    end
  end

  def edit
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.find_by_permalink(params[:id])

		# if dataset file obj not exist, build
		@visualization.visualization_translations.each do |trans|
			trans.build_dataset_file if !trans.dataset_file
		end

    new_layout = nil
    if params[:reset_crop] && I18n.available_locales.index(params[:reset_crop].to_sym)
logger.debug "************* reseting crop for #{params[:reset_crop]}"
			@locale_to_crop = params[:reset_crop]
			to_crop = @visualization.visualization_translations.select{|x| x.locale == @locale_to_crop}.first.image_record
			gon.largeW = to_crop.visual_geometry(:large).width
			gon.largeH = to_crop.visual_geometry(:large).height
			gon.originalW = to_crop.visual_geometry(:original).width
#      new_layout = 'fancybox' 
    elsif params[:reset_file] && I18n.available_locales.index(params[:reset_file].to_sym)
logger.debug "************* reseting file for #{params[:reset_file]}"
			@locale_to_reset = params[:reset_file]
#      new_layout = 'fancybox' 
    else 
		  locales_to_crop = @visualization.locales_to_crop
		  if !locales_to_crop.empty?
logger.debug "************* setting crop for #{locales_to_crop.first}"
			  @locale_to_crop = locales_to_crop.first
			  to_crop = @visualization.visualization_translations.select{|x| x.locale == @locale_to_crop}.first.image_record
			  gon.largeW = to_crop.visual_geometry(:large).width
			  gon.largeH = to_crop.visual_geometry(:large).height
			  gon.originalW = to_crop.visual_geometry(:original).width
		  else
logger.debug "************* load complete form"
			  @visualization.visualization_categories.build if @visualization.visualization_categories.nil? || @visualization.visualization_categories.empty?
		  end
    end

		gon.edit_visualization = true
		gon.visualization_type = @visualization.visualization_type_id
		gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
    
    if new_layout
      respond_to do |format|
        format.html { render :layout => new_layout}
        format.json { render json: @visualization }
      end
    end
  end

  def create
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.new(params[:visualization])

		# if interactive, take screen shots of urls
		if @visualization.visualization_type_id == Visualization::TYPES[:interactive]
logger.debug "//////////// is interactive, taking snapshots"
			files = Hash.new
			@visualization.visualization_translations.each do |trans|
logger.debug "//////////// - locale = #{trans.locale}"
				# only proceed if the url is valid
				if @visualization.languages_internal.index(trans.locale) && trans.valid? &&
						!trans.interactive_url.blank? && trans.image_file_name.blank?
logger.debug "//////////// -- records are valid, taking screen shot"
					# get screenshot of interactive site
          filename = Screenshot.take(trans.interactive_url)
          if filename
            files[trans.locale] = filename
					  trans.image_file.file = File.new(filename, 'r')
          end
=begin
					kit   = IMGKit.new(trans.interactive_url, :'javascript-delay' => 10000)
					img   = kit.to_img(:png)
					files[trans.locale] = Tempfile.new(["visual_screenshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}", '.png'], 'tmp',
										           :encoding => 'ascii-8bit')
					files[trans.locale].write(img)
					files[trans.locale].flush
logger.debug "//////////// -- adding image file"
					trans.image_file.file = files[trans.locale]
=end
				end
			end
		end

    respond_to do |format|
      if @visualization.save
        # if permalink is re-generated, the permalink value gotten through the translation object is not refreshed
        # - have to get it by hand
				permalink = @visualization.visualization_translations.select{|x| x.locale == I18n.locale.to_s}.first.permalink

        format.html { redirect_to edit_organization_visualization_path(params[:organization_id], permalink), notice: t('app.msgs.success_created', :obj => t('activerecord.models.visualization')) }
        format.json { render json: @visualization, status: :created, location: @visualization }
      else
				gon.edit_visualization = true
				gon.visualization_type = @visualization.visualization_type_id
				gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
        format.html { render action: "new" }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end

		# if a temp file was created, go ahead and delete it
		if !files.blank?
			files.keys.each do |key|
				File.delete(files[key])
			end
		end

=begin
		if !files.blank?
			files.keys.each do |key|
				files[key].unlink
			end
		end
=end
  end

  def update
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.find_by_permalink(params[:id])

		Visualization.transaction do
			files = Hash.new

		  # if reset crop flag set, reset image is cropped falg
		  reset_crop = false
		  params[:visualization][:visualization_translations_attributes].keys.each do |key|
			  x = params[:visualization][:visualization_translations_attributes][key][:image_file_attributes]
			  if x[:reset_crop] == "true"
				  x[:image_is_cropped] = false
				  reset_crop = true
			  end
		  end

      # if reload file flag is set, erase file record so that the new file will be processed
      # - and if this is interactive, retake screenshot
		  params[:visualization][:visualization_translations_attributes].keys.each do |key|
			  ptrans = params[:visualization][:visualization_translations_attributes][key]
			  if ptrans[:reload_file] == "true"
				  trans = @visualization.visualization_translations.select{|x| x.id.to_s == ptrans[:id]}.first
          # remove the file on record
          trans.image_file.file = nil
          trans.image_file.reload_file = true
#          trans.image_file.save

          # if this is interactive, redo screenshot
  				if trans.image_file.visualization_type_id == Visualization::TYPES[:interactive] && !ptrans[:interactive_url].blank?
  logger.debug "//////////// -- taking screen shot"
					  # get screenshot of interactive site
            filename = Screenshot.take(ptrans[:interactive_url])
            if filename
              files[trans.locale] = filename
					    trans.image_file.file = File.new(filename, 'r')
            end
          end

			  end
		  end
      

      respond_to do |format|
        if @visualization.update_attributes(params[:visualization])
				  # if the visuals need to be re-cropped, do it now
				  processed_crop = false
				  @visualization.visualization_translations.each do |trans|
					  if trans.image_record && (!trans.image_record.was_cropped && trans.image_record.image_is_cropped) || 
                (trans.image_record.redid_crop && trans.image_record.image_is_cropped)
						  trans.image_record.reprocess_file
						  processed_crop = true
					  end
				  end

          # if permalink is re-generated, the permalink value gotten through the translation object is not refreshed
          # - have to get it by hand
				  permalink = @visualization.visualization_translations.select{|x| x.locale == I18n.locale.to_s}.first.permalink

          format.html {
					  if processed_crop || reset_crop
						  # show form again
						  redirect_to edit_organization_visualization_path(params[:organization_id], permalink),
									  notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization'))
					  else
						  # redirect to show page
						  redirect_to organization_visualization_path(params[:organization_id], permalink),
									  notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization'))
					  end
				  }
          format.json { head :ok }
        else
				  gon.edit_visualization = true
				  gon.visualization_type = @visualization.visualization_type_id
				  gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
          format.html { render action: "edit" }
          format.json { render json: @visualization.errors, status: :unprocessable_entity }
        end
      end

		  # if a temp file was created, go ahead and delete it
		  if !files.blank?
			  files.keys.each do |key|
				  File.delete(files[key])
			  end
		  end

    end
  end

  def destroy
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.find_by_permalink(params[:id])
    @visualization.destroy

    respond_to do |format|
      format.html { redirect_to visualizations_path(params[:organization_id]) }
      format.json { head :ok }
    end
  end

protected

  def next_previous(type)
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
    redirect_to(visualizations_path, :alert => t("app.common.page_not_found"))
    return
  end
end
