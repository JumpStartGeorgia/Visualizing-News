class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter(:except => [:show]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter(:except => [:show]) do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:id])
  end


  def show
    gon.vis_ajax_path = organization_path(:id => params[:id], :format => :js)
    @visualizations = Visualization.recent.page(params[:page])
		@organization = Organization.where(:organization_translations => {:permalink => params[:id]}).with_name.first

		if @organization
			# see if user is in this org
		 	#@visualizations = Visualization.recent.page(params[:page])
			@user_in_org = false
Rails.logger.debug "------------------- init user_in_org = #{@user_in_org}"
			if user_signed_in? && current_user.organization_ids.index(@organization.id)
				@user_in_org = true
			end
Rails.logger.debug "------------------- after check user_in_org = #{@user_in_org}"

      process_visualization_querystring # in app controller

		  respond_to do |format|
		    format.html
        format.js {
          screen_w = params[:screen_w].nil? ? 4 : params[:screen_w].to_i
          vis_w = 270
          gi_w = vis_w
          menu_w = 200
          max = 5
          min = 3
          number = (screen_w - menu_w - gi_w) / vis_w
          if number > max
            number = max
          elsif number < min
            number = min
          end
          number *= 2
		      @visualizations = Visualization.recent.page(params[:page]).per(number)
Rails.logger.debug "------------------- testing if user not in org to add published field"
			    if !@user_in_org
Rails.logger.debug "---------------------> user not in org, adding published field"
			      @visualizations = @visualizations.published
			    end
          @ajax_call = true
          render 'shared/index'
        }
		  end

		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
		end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find_by_permalink(params[:id])
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find_by_permalink(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        # if permalink is re-generated, the permalink value gotten through the translation object is not refreshed
        # - have to get it by hand
        format.html { redirect_to organization_path(@organization.organization_translations.select{|x| x.locale == I18n.locale.to_s}.first.permalink), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.user')) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

end
