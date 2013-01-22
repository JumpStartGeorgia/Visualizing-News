class Ideas::ProgressController < ApplicationController
	layout "fancybox"

	def claim
		@idea = Idea.find_by_id(params[:idea_id])
		@org = Organization.find_by_id(params[:organization_id])
		@idea_progress = IdeaProgress.new

		gon.edit_idea_progress = true

		render :form
	end

	def new
		@idea = Idea.find_by_id(params[:idea_id])
		@org = Organization.find_by_id(params[:organization_id])
		@idea_progress = IdeaProgress.new

		gon.edit_idea_progress = true

		render :form
	end

	def edit
		@idea_progress = IdeaProgress.find_by_id(params[:id])
		@idea = Idea.find_by_id(@idea_progress.idea_id)
		@org = Organization.find_by_id(@idea_progress.organization_id)

		gon.edit_idea_progress = true
		gon.progress_date = @idea_progress.progress_date.strftime('%m/%d/%Y') if !@idea_progress.progress_date.nil?

		render :form
	end

	def create
    @idea_progress = IdeaProgress.new(params[:idea_progress])

    respond_to do |format|
      if @idea_progress.save
        format.html { redirect_to idea_path(@idea_progress.idea_id), notice: t('activerecord.messages.idea_progress.success') }
        format.json { render json: @idea_progress, status: :created, location: @idea_progress }
      else
				@idea = Idea.find_by_id(@idea_progress.idea_id)
				@org = Organization.find_by_id(@idea_progress.organization_id)
				gon.edit_idea_progress = true
				gon.progress_date = @idea_progress.progress_date.strftime('%m/%d/%Y') if !@idea_progress.progress_date.nil?
        format.html { render :form }
        format.json { render json: @idea_progress.errors, status: :unprocessable_entity }
      end
    end
	end

  def update
    @idea_progress = IdeaProgress.find(params[:id])

    respond_to do |format|
      if @idea_progress.update_attributes(params[:idea_progress])
        format.html { redirect_to idea_path(@idea_progress.idea_id), notice: t('activerecord.messages.idea_progress.success') }
        format.json { head :ok }
      else
				@idea = Idea.find_by_id(@idea_progress.idea_id)
				@org = Organization.find_by_id(@idea_progress.organization_id)
				gon.edit_idea_progress = true
				gon.progress_date = @idea_progress.progress_date.strftime('%m/%d/%Y') if !@idea_progress.progress_date.nil?
        format.html { render :form }
        format.json { render json: @idea_progress.errors, status: :unprocessable_entity }
      end
    end
  end

end
