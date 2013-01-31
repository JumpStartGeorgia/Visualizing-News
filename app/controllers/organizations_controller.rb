class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter(:except => [:show]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter(:except => [:show]) do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:id])
  end


  def show
		@organization = Organization.where(:organization_translations => {:permalink => params[:id]}).with_name.first

		if @organization
			# see if user is in this org
			@user_in_org = false
      if user_signed_in? && !current_user.organization_ids.index(@organization.id).nil?
				@user_in_org = true
			end

      @param_options[:format] = :js
      @param_options[:max] = 5
      @param_options[:org] = params[:id]
      gon.ajax_path = visuals_ajax_path(@param_options)

      set_visualization_view_type # in app controller

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
