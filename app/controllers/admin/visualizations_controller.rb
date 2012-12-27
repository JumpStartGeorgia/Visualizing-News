class Admin::VisualizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  # GET /visualizations
  # GET /visualizations.json
  def index
    @visualizations = Visualization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @visualizations }
    end
  end

  # GET /visualizations/1
  # GET /visualizations/1.json
  def show
    @visualization = Visualization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @visualization }
    end
  end

  # GET /visualizations/new
  # GET /visualizations/new.json
  def new
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

  # GET /visualizations/1/edit
  def edit
    @visualization = Visualization.find(params[:id])
		@visualization.visualization_categories.build if @visualization.visualization_categories.nil? || @visualization.visualization_categories.empty?

		gon.edit_visualization = true
		gon.visualization_type = @visualization.visualization_type_id
		gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?

  end

  # POST /visualizations
  # POST /visualizations.json
  def create
    @visualization = Visualization.new(params[:visualization])

    respond_to do |format|
      if @visualization.save
        format.html { redirect_to admin_visualization_path(@visualization), notice: t('app.msgs.success_created', :obj => t('activerecord.models.visualization')) }
        format.json { render json: @visualization, status: :created, location: @visualization }
      else
				gon.edit_visualization = true
				gon.visualization_type = @visualization.visualization_type_id
				gon.published_date = @visualization.published_date.strftime('%m/%d/%Y') if !@visualization.published_date.nil?
        format.html { render action: "new" }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /visualizations/1
  # PUT /visualizations/1.json
  def update
    @visualization = Visualization.find(params[:id])

    respond_to do |format|
      if @visualization.update_attributes(params[:visualization])
        format.html { redirect_to admin_visualization_path(@visualization), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization')) }
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

  # DELETE /visualizations/1
  # DELETE /visualizations/1.json
  def destroy
    @visualization = Visualization.find(params[:id])
    @visualization.destroy

    respond_to do |format|
      format.html { redirect_to admin_visualizations_url }
      format.json { head :ok }
    end
  end
end
