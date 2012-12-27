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

  def show
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])

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
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.new
		gon.edit_visualization = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @visualization }
    end
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])

		if @visualization.visual_is_cropped
logger.debug "----------- visual is cropped"
		  # create the translation object for however many locales there are
		  # so the form will properly create all of the nested form fields
logger.debug "---------- has trans records: #{@visualization.visualization_translations.map {|x| x.locale}.inspect}"
			if @visualization.visualization_translations.length != I18n.available_locales.length
logger.debug "---------- record does not have all locales"
				I18n.available_locales.each do |locale|
logger.debug "---------- locale: #{locale}, already exists = #{@visualization.visualization_translations.index{|x| x.locale == locale.to_s}}"
					@visualization.visualization_translations.build(:locale => locale.to_s) if !@visualization.visualization_translations.index{|x| x.locale == locale.to_s}
				end
			end
logger.debug "-------------- vis trans = #{@visualization.visualization_translations.map {|x| x.locale}.inspect}"
			@visualization.visualization_categories.build if @visualization.visualization_categories.nil? || @visualization.visualization_categories.empty?
		else
logger.debug "----------- visual is NOT cropped"
			gon.largeW = @visualization.visual_geometry(:large).width
			gon.largeH = @visualization.visual_geometry(:large).height
			gon.originalW = @visualization.visual_geometry(:original).width
		end

		gon.edit_visualization = true
		gon.visualization_type = @visualization.visualization_type_id
		gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?

  end

  def create
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.new(params[:visualization])

		if @visualization.visualization_type_id == Visualization::TYPES[:interactive] &&
			@visualization.interactive_url && !@visualization.interactive_url.empty? &&
			@visualization.visual_file_name.nil?
			# get screenshot of interactive site
			kit   = IMGKit.new(@visualization.interactive_url)
			img   = kit.to_img(:png)
			file  = Tempfile.new(["visual_screenshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}", '.png'], 'tmp',
						               :encoding => 'ascii-8bit')
			file.write(img)
			file.flush
			@visualization.visual = file
		end

    respond_to do |format|
      if @visualization.save
        format.html { redirect_to edit_organization_visualization_path(@organization, @visualization), notice: t('app.msgs.success_created', :obj => t('activerecord.models.visualization')) }
        format.json { render json: @visualization, status: :created, location: @visualization }
      else
				gon.edit_visualization = true
				gon.visualization_type = @visualization.visualization_type_id
				gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
        format.html { render action: "new" }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end
		file.unlink if file
  end

  def update
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])
		was_cropped = @visualization.visual_is_cropped

    respond_to do |format|

      if @visualization.update_attributes(params[:visualization])
        format.html {
					if !was_cropped && @visualization.visual_is_cropped
						# image was just cropped, show complete form
						gon.edit_visualization = true
						gon.visualization_type = @visualization.visualization_type_id
						gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
						redirect_to edit_organization_visualization_path(@organization, @visualization), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization'))
					else
						# redirect to show page
						redirect_to organization_visualization_path(@organization, @visualization), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization'))
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
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])
    @visualization.destroy

    respond_to do |format|
      format.html { redirect_to organization_path(params[:organization_id]) }
      format.json { head :ok }
    end
  end
end
