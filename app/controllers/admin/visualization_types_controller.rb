class Admin::VisualizationTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  # GET /visualization_types
  # GET /visualization_types.json
  def index
    @visualization_types = VisualizationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @visualization_types }
    end
  end

  # GET /visualization_types/1
  # GET /visualization_types/1.json
  def show
    @visualization_type = VisualizationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @visualization_type }
    end
  end

  # GET /visualization_types/new
  # GET /visualization_types/new.json
  def new
    @visualization_type = VisualizationType.new
    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
			@visualization_type.visualization_type_translations.build(:locale => locale)
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @visualization_type }
    end
  end

  # GET /visualization_types/1/edit
  def edit
    @visualization_type = VisualizationType.find(params[:id])
  end

  # POST /visualization_types
  # POST /visualization_types.json
  def create
    @visualization_type = VisualizationType.new(params[:visualization_type])

    respond_to do |format|
      if @visualization_type.save
        format.html { redirect_to admin_visualization_type_path(@visualization_type), notice: t('app.msgs.success_created', :obj => t('activerecord.models.visualization_type')) }
        format.json { render json: @visualization_type, status: :created, location: @visualization_type }
      else
        format.html { render action: "new" }
        format.json { render json: @visualization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /visualization_types/1
  # PUT /visualization_types/1.json
  def update
    @visualization_type = VisualizationType.find(params[:id])

    respond_to do |format|
      if @visualization_type.update_attributes(params[:visualization_type])
        format.html { redirect_to admin_visualization_type_path(@visualization_type), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.visualization_type')) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @visualization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visualization_types/1
  # DELETE /visualization_types/1.json
  def destroy
    @visualization_type = VisualizationType.find(params[:id])
    @visualization_type.destroy

    respond_to do |format|
      format.html { redirect_to admin_visualization_types_url }
      format.json { head :ok }
    end
  end
end
