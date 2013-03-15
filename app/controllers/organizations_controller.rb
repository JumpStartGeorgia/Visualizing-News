class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:org_admin])
  end
  before_filter do |controller_instance|
    controller_instance.send(:assigned_to_org?, params[:id])
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find_by_permalink(params[:id])

    if !@organization.present?
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find_by_permalink(params[:id])

    if @organization.present?
      respond_to do |format|
        if @organization.update_attributes(params[:organization])
          # if permalink is re-generated, the permalink value gotten through the translation object is not refreshed
          # - have to get it by hand
          format.html { redirect_to visualizations_path(:organization => @organization.organization_translations.select{|x| x.locale == I18n.locale.to_s}.first.permalink), notice: t('app.msgs.success_updated', :obj => t('activerecord.models.organization')) }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @organization.errors, status: :unprocessable_entity }
        end
      end
    else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
    end
  end

end
