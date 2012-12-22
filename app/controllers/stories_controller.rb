####################
# this controller is used in conjuction with the organization controller
# when a user is an org_admin and can add/edit visualizations
####################
class StoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:organization_id])
  end

  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  def new
    @story = Story.new
    # create the translation object for however many locales there are
    # so the form will properly create all of the nested form fields
    I18n.available_locales.each do |locale|
			@story.story_translations.build(:locale => locale)
		end
		@story.story_categories.build
		gon.edit_story = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  def edit
    @story = Story.find(params[:id])
		@story.story_categories.build if @story.story_categories.nil? || @story.story_categories.empty?

		gon.edit_story = true
		gon.published_date = @story.published_date.strftime('%m/%d/%Y') if !@story.published_date.nil?

  end

  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to organization_visualization_path(@story), notice: t('app.msgs.success_created', :obj => t('activerecord.models.story')) }
        format.json { render json: @story, status: :created, location: @story }
      else
				gon.edit_story = true
				gon.published_date = @story.published_date.strftime('%m/%d/%Y') if !@story.published_date.nil?
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to organization_visualization_path(@story), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.story')) }
        format.json { head :ok }
      else
				gon.edit_story = true
				gon.published_date = @story.published_date.strftime('%m/%d/%Y') if !@story.published_date.nil?
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to organization_path(params[:organization_id]) }
      format.json { head :ok }
    end
  end
end
