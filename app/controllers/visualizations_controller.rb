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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @visualization }
    end
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.new
    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
			@visualization.visualization_translations.build(:locale => locale)
		end
		@visualization.visualization_categories.build
		gon.edit_visualization = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @visualization }
    end
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])
		@visualization.visualization_categories.build if @visualization.visualization_categories.nil? || @visualization.visualization_categories.empty?

		gon.edit_visualization = true
		gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?

  end

  def create
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.new(params[:visualization])

    respond_to do |format|
      if @visualization.save
        format.html { redirect_to organization_visualization_path(@organization, @visualization), notice: t('app.msgs.success_created', :obj => t('activerecord.models.visualization')) }
        format.json { render json: @visualization, status: :created, location: @visualization }
      else
				gon.edit_visualization = true
				gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
        format.html { render action: "new" }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @organization = Organization.find(params[:organization_id])
    @visualization = Visualization.find(params[:id])

    respond_to do |format|
      if @visualization.update_attributes(params[:visualization])
        format.html { redirect_to organization_visualization_path(@organization, @visualization), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization')) }
        format.json { head :ok }
      else
				gon.edit_visualization = true
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
