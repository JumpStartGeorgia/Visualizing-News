class Admin::IdeaStatusesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  # GET /idea_statuses
  # GET /idea_statuses.json
  def index
    @idea_statuses = IdeaStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @idea_statuses }
    end
  end

  # GET /idea_statuses/1
  # GET /idea_statuses/1.json
  def show
    @idea_status = IdeaStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @idea_status }
    end
  end

  # GET /idea_statuses/new
  # GET /idea_statuses/new.json
  def new
    @idea_status = IdeaStatus.new
    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
			@idea_status.idea_status_translations.build(:locale => locale)
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @idea_status }
    end
  end

  # GET /idea_statuses/1/edit
  def edit
    @idea_status = IdeaStatus.find(params[:id])
  end

  # POST /idea_statuses
  # POST /idea_statuses.json
  def create
    @idea_status = IdeaStatus.new(params[:idea_status])

    respond_to do |format|
      if @idea_status.save
        format.html { redirect_to admin_idea_status_path(@idea_status), notice: t('app.msgs.success_created', :obj => t('activerecord.models.idea_status')) }
        format.json { render json: @idea_status, status: :created, location: @idea_status }
      else
        format.html { render action: "new" }
        format.json { render json: @idea_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /idea_statuses/1
  # PUT /idea_statuses/1.json
  def update
    @idea_status = IdeaStatus.find(params[:id])

    respond_to do |format|
      if @idea_status.update_attributes(params[:idea_status])
        format.html { redirect_to admin_idea_status_path(@idea_status), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.idea_status')) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @idea_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /idea_statuses/1
  # DELETE /idea_statuses/1.json
  def destroy
    @idea_status = IdeaStatus.find(params[:id])
    @idea_status.destroy

    respond_to do |format|
      format.html { redirect_to idea_statuses_url }
      format.json { head :ok }
    end
  end
end
