####################
# /organization/[name]/visualizations/....
# this controller is used in conjuction with the organization controller
# when a user is an org_admin and can add/edit visualizations
####################
class VisualizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:organization_id])
  end

  # for taking screen shots  
  require "headless"
  require "selenium-webdriver"

  def show
    @organization = Organization.find_by_permalink(params[:organization_id])
    @visualization = Visualization.find_by_permalink(params[:id])

		if @visualization
			if @visualization.visualization_type_id == Visualization::TYPES[:interactive] && params[:view] == 'interactive'
			  @view_type = 'shared/show_interactive'
				gon.show_interactive = true
			else
			  @view_type = 'shared/show'
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

		locales_to_crop = @visualization.locales_to_crop
		if !locales_to_crop.empty?
			@locale_to_crop = locales_to_crop.first
			to_crop = @visualization.visualization_translations.select{|x| x.locale == @locale_to_crop}.first.image_record
			gon.largeW = to_crop.visual_geometry(:large).width
			gon.largeH = to_crop.visual_geometry(:large).height
			gon.originalW = to_crop.visual_geometry(:original).width
		else
			@visualization.visualization_categories.build if @visualization.visualization_categories.nil? || @visualization.visualization_categories.empty?
		end

		gon.edit_visualization = true
		gon.visualization_type = @visualization.visualization_type_id
		gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?

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

          headless = Headless.new
          headless.start
          driver = Selenium::WebDriver.for :chrome
          driver.navigate.to trans.interactive_url
          sleep 8
          filename = "#{Rails.root}/tmp/visual_screenshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
          driver.save_screenshot(filename)
          driver.quit
          headless.destroy
          files[trans.locale] = filename
					trans.image_file.file = File.new(filename, 'r')

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

		# if reset crop flag set, reset image is cropped falg
		reset_crop = false
		params[:visualization][:visualization_translations_attributes].keys.each do |key|
			x = params[:visualization][:visualization_translations_attributes][key][:image_file_attributes]
			if x[:reset_crop] == "true"
				x[:image_is_cropped] = false
				reset_crop = true
			end
		end

    respond_to do |format|
      if @visualization.update_attributes(params[:visualization])
				# if the visuals need to be re-cropped, do it now
				processed_crop = false
				@visualization.visualization_translations.each do |trans|
					if trans.image_record && !trans.image_record.was_cropped && trans.image_record.image_is_cropped
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
