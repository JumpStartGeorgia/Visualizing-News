####################
# /organization/[name]/visualizations/....
# this controller is used in conjuction with the organization controller
# when a user is an org_admin and can add/edit visualizations
####################
class VisualizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter(:only => [:show]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:user])
  end
  before_filter(:except => [:show]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:organization_id])
  end

  require 'screenshot'

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
    @visualization.languages_internal = @visualization.visualization_translations.map{|x| x.locale}
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
    if params[:reset_crop].present? && I18n.available_locales.index(params[:reset_crop].to_sym)
logger.debug "************* reseting crop for #{params[:reset_crop]}"
			@locale_to_crop = params[:reset_crop]
			to_crop = @visualization.visualization_translations.select{|x| x.locale == @locale_to_crop}.first.image_record
			gon.largeW = to_crop.visual_geometry(:large).width
			gon.largeH = to_crop.visual_geometry(:large).height
			gon.originalW = to_crop.visual_geometry(:original).width
#      new_layout = 'fancybox' 
    elsif params[:reset_file].present? && I18n.available_locales.index(params[:reset_file].to_sym)
logger.debug "************* reseting file for #{params[:reset_file]}"
			@locale_to_reset = params[:reset_file]
#      new_layout = 'fancybox' 

    elsif params[:reset_languages].present?
      @reset_lanaguages = true
      # make sure any missing translation locales are added
      if @visualization.visualization_translations.length != I18n.available_locales.length
        I18n.available_locales.each do |locale|
          @visualization.visualization_translations.build(:locale => locale.to_s) if !@visualization.visualization_translations.index{|x| x.locale == locale.to_s}
          # add image file record
          x = @visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first
          x.build_image_file if x.image_file.blank?
        end
      end

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

    # only keep translation records for languages that are selected
    locales_to_remove = I18n.available_locales.map{|x| x.to_s} - @visualization.languages_internal
    if locales_to_remove.present?
      locales_to_remove.each do |locale|
        @visualization.visualization_translations.delete_if{|x| x.locale == locale}
      end
    end

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

        if @visualization.visualization_translations.length != I18n.available_locales.length
          I18n.available_locales.each do |locale|
            @visualization.visualization_translations.build(:locale => locale.to_s) if !@visualization.visualization_translations.index{|x| x.locale == locale.to_s}
            # add image file record
            x = @visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first
            x.build_image_file if x.image_file.blank?
          end
        end

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
    @visualization = Visualization.readonly(false).find_by_permalink(params[:id])

		Visualization.transaction do
			files = Hash.new

      # if reset languages selected, destory any translation records no longer needed
      reset_languages = false
      if params[:visualization][:reset_languages].present? && params[:visualization][:reset_languages] == 'true'
        reset_languages = true
        logger.debug "%%%%%% reset lang!"
        # inidcate if need to destroy existing langauges
        locales_to_remove = I18n.available_locales.map{|x| x.to_s} - params[:visualization][:languages_internal]
        if locales_to_remove.present?
          locales_to_remove.each do |locale|
            x = params[:visualization][:visualization_translations_attributes].values.select{|x| x[:locale] == locale}.first
            if x.present?
              if x[:id].present?
                # mark it for destruction
                x[:_destroy] = "1"
              else
                # not in database, so just delete the key/value pair
                params[:visualization][:visualization_translations_attributes].delete_if{|k,v| v[:locale] == locale}
              end
            end
          end
        end

        logger.debug "%%%%%%% attributes now #{params[:visualization][:visualization_translations_attributes].values}"

        # if there is a new language, record that we need to make a thumbnail of the image
        # if interactive and new, take screen shots of urls
        if params[:visualization][:visualization_type_id] == Visualization::TYPES[:interactive]
    logger.debug "//////////// is interactive, taking snapshots"
    #       @visualization.visualization_translations.each do |trans|
    # logger.debug "//////////// - locale = #{trans.locale}"
    #         # only proceed if the url is valid
    #         if @visualization.languages_internal.index(trans.locale) && trans.valid? &&
    #             !trans.interactive_url.blank? && trans.image_file_name.blank?
    # logger.debug "//////////// -- records are valid, taking screen shot"
    #           # get screenshot of interactive site
    #           filename = Screenshot.take(trans.interactive_url)
    #           if filename
    #             files[trans.locale] = filename
    #             trans.image_file.file = File.new(filename, 'r')
    #           end
    #         end
    #       end
        end

      end 

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
					  if processed_crop || reset_crop || reset_languages
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
      format.html { redirect_to organization_path(params[:organization_id]) }
      format.json { head :ok }
    end
  end
end
