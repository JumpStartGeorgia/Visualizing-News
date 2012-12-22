class OrganizationController < ApplicationController

  def index
		@organization = Organization.where(:id => params[:id]).with_name.first

		if @organization
			# see if user is in this org
		  @stories = Story.recent.page(params[:page])
			if !user_signed_in? || current_user.organization_ids.index(@organization.id).nil?
			  @stories = @stories.published
			end

		  respond_to do |format|
		    format.html
	      format.js {render 'visuals/index'}
		  end

		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
		end
  end

end
